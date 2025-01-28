const cds = require('@sap/cds/lib')
const { default: axios } = require('axios') 
const { GET, POST, DELETE, PATCH, expect } = cds.test(__dirname + '../../', '--with-mocks');

axios.defaults.auth = { username: 'incident.support@tester.sap.com', password: 'initial' }

jest.setTimeout(11111)
