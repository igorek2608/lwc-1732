/* eslint-disable @lwc/lwc/no-async-operation */
import { LightningElement, track, wire, api } from "lwc";
import getUserCases from "@salesforce/apex/ServiceCaseQueueService.getUserCases";
import { subscribe, unsubscribe, onError } from "lightning/empApi";
import generateServiceCaseData from './generateServiceCaseData';
import { refreshApex } from '@salesforce/apex';
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import { updateRecord } from 'lightning/uiRecordApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import STATUS_FIELD from "@salesforce/schema/Case.Status";
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


 




export default class ServiceCaseQueueFiltered extends LightningElement() {
       columns = [
        { label: 'Case Number', fieldName: 'CaseNumberUrl', type: 'url', sortable: false, typeAttributes: { label: { fieldName: 'CaseNumber' }, target: '_blank' } },
        { label: 'Assignee', fieldName: 'Owner_Name__c', type: 'text', sortable: false },
        { label: 'Priority', fieldName: 'Priority', type: 'text', sortable: false },
        { label: 'Origin', fieldName: 'Origin', type: 'text', sortable: false },

    ];
    @track cases = [];
    statusOptions = [];
    isLoading = false;
    defaultRecordTypeId;
   

    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    getCaseInfo({ data, error }) {
        if (data) {
            console.log('getCaseInfo')
           
            this.defaultRecordTypeId = data.defaultRecordTypeId;
             console.log(this.defaultRecordTypeId)
        }
        else if (error) {
            console.log(error);
        }
    };

    @wire(getPicklistValues, { recordTypeId: '$defaultRecordTypeId', fieldApiName: STATUS_FIELD })
    wiredGetStatusOptions({ data, error }) {
        if (data) {
            this.statusOptions = data.values;
            this.columns = [
                ...this.columns.slice(0, 2),
                {
                    label: 'Case Status',
                    fieldName: 'Status',
                    type: 'picklist',
                    editable: false,
                    typeAttributes: {
                        placeholder: 'Choose Status',
                        options: this.statusOptions,
                        value: { fieldName: 'Status' },
                        context: { fieldName: 'Id' },
                        variant: 'label-hidden',
                        name: 'Status',
                        label: 'Case Status'
                    }
                },
                ...this.columns.slice(2)
            ];

            console.log('col')
            console.log(this.columns)
        }
        if (error) {
            console.log(error)
        }
    }

    wiredCases;
    @wire(getUserCases)
    wiredGetUserCases(wireResult) {
        const { data, error } = wireResult;
        this.wiredCases = wireResult;
        console.log(data)
        this.isLoading = true;
        if (data) {
            this.cases = data.map(record => ({
                ...record,
                CaseNumberUrl: `/${record.Id}`,
            }));
            
        }
        if (error) {
            console.log(error)
        }
        this.isLoading = false;
    }

    handleValueChange(event) {
        const updatedCaseRecord = {
            fields: {
                Id: event.detail.data.context,
                Status: event.detail.data.value
            }
        };
        console.log('handleValueChange')
        console.log(event)
        console.log(updatedCaseRecord)
        updateRecord(updatedCaseRecord)
            .then(() => {
                this.showToast('Success', 'Record updated successfully', 'success');
                this.handleRefresh();
            })
            .catch(error => {
                this.showToast('Error updating record', error.body.message, 'error');
            })
    }

    handleRefresh() {
        this.isLoading = true;
        refreshApex(this.wiredCases).finally(() => {
            this.isLoading = false;
        });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}
