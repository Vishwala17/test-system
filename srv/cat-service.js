const cds = require('@sap/cds');
const { Tests, Questions, Answers, Suppliers} = cds.entities('DevChallengeService');
const { v4: uuidv4 } = require('uuid');


module.exports = class DevChallengeService extends cds.ApplicationService {
  async init() {
    // Assign Questions to Test
    this.on('assignQuestionsToTest', 'Tests', async (req) => {
      const { testId, questionsCount } = req.data;

      if (questionsCount < 1) {
        return { message: 'The number of questions must be at least 1.' };
      }

      const test = await SELECT.one.from(Tests).where({testId});
    
      if (!test) {
          return req.error(404, `Test with ID ${testId} is not found`);
        }


        console.log('Assigned test ID:', testId)   
    

      const questions = await cds.tx(req).run(
        SELECT.from('Questions').where({ test_testId: null }).limit(questionsCount)  // Changed to `test_testId`
      );
    
      if (questions.length === 0) {
        return req.error(400, 'No unassigned questions available. Please create new questions.');
      }
    
      const availableQuestionsCount = questions.length;
    
      if (availableQuestionsCount < questionsCount) {
        return req.error(400, `Only ${availableQuestionsCount} questions are available. The requested ${questionsCount - availableQuestionsCount} questions were not available.`);
      }
    

      await cds.tx(req).run(
        UPDATE('Questions')
          .set({ test_testId: testId }) 
          .where({ questionId: { in: questions.map(q => q.questionId) } })
      );


      console.log("Assigning test ID:", testId, "to questions with IDs:", questions.map(q => q.questionId));


      const updatedQuestions = await cds.tx(req).run(
        SELECT.from('Questions').where({ test_testId: testId })
      );
      console.log("Updated Questions:", updatedQuestions);

      await cds.tx(req).run(
        UPDATE('Tests').set({ lastUpdated: new Date() }).where({ testId: testId })
      );
    
      return { message: `Assigned ${questionsCount} questions successfully to the test.` };
    });
    

    this.on('createQuestions', 'Tests', async (req) => {
      const { questionText, answerText, testId } = req.data;
      console.log('Received data:', req.data);
  
      const Text = questionText || '';
      const Answer = answerText || '';
      const tx = cds.tx(req);
  
      try {
          const questionId = uuidv4();
          const answerId = uuidv4();

          const newQuestion = await tx.run(
              INSERT.into('Questions').entries({
                  questionId: questionId,
                  text: Text,
                  test_testId: testId, 
                  answer: { 
                      answerId: answerId,
                      text: Answer
                  }
              })
          );
  
          console.log('Inserted new question:', newQuestion);
  
          await tx.commit();
  
          return { message: 'Question and answer created successfully.', question: newQuestion, answer: Answer };
      } catch (error) {
          console.error('Error inserting question and answer:', error);
          await tx.rollback();
          return { message: 'Failed to create question and answer.' };
      }
  });
  
    const bupa = await cds.connect.to('API_BUSINESS_PARTNER');

    // Risks?$expand=supplier
    this.on("READ", 'Tests', async (req, next) => {
      if (!req.query.SELECT.columns) return next();
      const expandIndex = req.query.SELECT.columns.findIndex(
          ({ expand, ref }) => expand && ref[0] === "supplier"
      );
      if (expandIndex < 0) return next();
  
      // Remove expand from query
      req.query.SELECT.columns.splice(expandIndex, 1);
  
      // Make sure supplier_ID will be returned
      if (!req.query.SELECT.columns.indexOf('*') >= 0 &&
          !req.query.SELECT.columns.find(
              column => column.ref && column.ref.find((ref) => ref == "supplier_ID"))
      ) {
          req.query.SELECT.columns.push({ ref: ["supplier_ID"] });
      }
  
      const risks = await next();
  
      const asArray = x => Array.isArray(x) ? x : [ x ];
  
      // Request all associated suppliers
      const supplierIds = asArray(risks).map(risk => risk.supplier_ID);
      const suppliers = await bupa.run(SELECT.from(Suppliers).where({ ID: supplierIds }));
  
      // Convert in a map for easier lookup
      const suppliersMap = {};
      for (const supplier of suppliers)
          suppliersMap[supplier.ID] = supplier;
  
      // Add suppliers to result
      for (const note of asArray(risks)) {
          note.supplier = suppliersMap[note.supplier_ID];
      }
  
      return risks;
  });
  
  
  this.on('READ', 'Suppliers', async req => {
      return bupa.run(req.query);
  });
  
          return super.init();
      }
  };
