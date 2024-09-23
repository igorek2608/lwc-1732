/* eslint-disable @lwc/lwc/no-async-operation */
import { LightningElement, track, wire, api } from "lwc";
import getUserCases from "@salesforce/apex/ServiceCaseQueueService.getUserCases";
import { subscribe, unsubscribe, onError } from "lightning/empApi";







export default class ServiceCaseQueueFiltered extends LightningElement() {
    cases;
    subscription = {};
    channelName = "/event/Case_Changed__e";
    isLoading = false;
    

    connectedCallback() {
        this.getUserCasesAll();
        this.handleSubscribe();
        this.registerErrorListener();
    }

    getUserCasesAll() {
        getUserCases()
            .then((result) => {
                console.log(result)
                this.isLoading = false;
                this.cases = result;
            })
            .catch((error) => {
                this.error = error;
            });
    }

    reloadPage() {
        console.log('reload')
        setTimeout(() => {
            console.log(this.isLoading)
            this.isLoading = true;
            this.getUserCasesAll();
            console.log(this.isLoading)
        }, 1000);
    }

    handleSubscribe() {
        const thisContext  = this;
        const messageCallback = function (response) {
            thisContext .handleEvent(response);
        };

        subscribe(this.channelName, -1, messageCallback)
            .then((response) => {
                thisContext.subscription = response;
                thisContext.handleEvent();
            })
            .catch((e) => {
                console.log(e);
            });
    }

    registerErrorListener() {
        // Invoke onError empApi method
        onError((error) => {
            console.log("Received error from server: ", JSON.stringify(error));
            // Error contains the server-side error
        });
    }

    handleEvent = (response) => {
        setTimeout(() => {
            const that = this;
            const actions = response && response.data && response.data.payload && response.data.payload.Action__c ? response.data.payload.Action__c : '';
            if (
                actions === "Update" ||
                actions === "Insert" ||
                actions === "Delete"
            ) {

                console.log('loading')
                console.log(this.isLoading)
                this.isLoading = true;
                return that.getUserCasesAll();
            }
        }, 2000);
    };
}
