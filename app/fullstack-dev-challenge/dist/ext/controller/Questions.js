sap.ui.define(["sap/ui/core/mvc/Controller","sap/m/MessageToast"],(e,o)=>{"use strict";return e.extend("ui5.walkthrough.controller.HelloPanel",{onShowHello(){const e=this.getView().getModel("i18n").getResourceBundle();const t=this.getView().getModel().getProperty("/recipient/name");const l=e.getText("helloMsg",[t]);o.show(l)},async onOpenDialog(){this.oDialog??=await this.loadFragment({name:"ui5.walkthrough.view.HelloDialog"});this.oDialog.open()}})});
//# sourceMappingURL=Questions.js.map