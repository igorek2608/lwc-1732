import { LightningElement, wire, api, track } from "lwc";
import { getObjectInfo } from "lightning/uiObjectInfoApi"; //GET OBJECT
import { getPicklistValues } from "lightning/uiObjectInfoApi"; //GET VALUES PICKLIST
import { refreshApex } from "@salesforce/apex";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { updateRecord } from "lightning/uiRecordApi";
import ID from "@salesforce/schema/Case.Id";
import CASE from "@salesforce/schema/Case";
import STATUS_FIELD from "@salesforce/schema/Case.Status";

export default class CaseCombobox extends LightningElement {
    case;

    get cs () {
        return this.case;
    }

    @api set cs (value) {
        this.setAttribute("cs", value);
        this.case = value;
    }

    @api objectApiName;
    @api message;
    @track caseStatusList;
    @track value;
    @track selValue;

    @wire(getObjectInfo, { objectApiName: CASE }) objectInfo;
    @wire(getPicklistValues, { recordTypeId: "$objectInfo.data.defaultRecordTypeId", fieldApiName: STATUS_FIELD })
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.caseStatusList = data.values;
        } else {
            console.log(error);
        }
    }

    handleChange(event) {
        this.isLoading = true;
        let selOption = event.target.value;
        this.selValue = selOption;
        let prevValue;
        const fields = {};
        fields[ID.fieldApiName] = this.case.Id;
        fields[STATUS_FIELD.fieldApiName] = this.selValue;
        const recordInput = { fields };

        updateRecord(recordInput, prevValue)
            .then(() => {
                this.isLoading = true;
                this.dispatchEvent(
                    new ShowToastEvent({
                        
                        title: "Success",
                        message: "Case updated",
                        variant: "success"
                    })
                );
                this.prevValue = selOption;
                this.isLoading = false;
                refreshApex(this.case);
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: "Error updating or reloading record",
                        message: error.body.message,
                        variant: "error"
                    })
                );
                this.value = this.prevValue;
                this.isLoading = false;
                refreshApex(this.case);
            });
    }
}