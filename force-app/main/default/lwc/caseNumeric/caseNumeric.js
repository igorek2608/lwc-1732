import { LightningElement, api } from 'lwc';
   
export default class CaseNumeric extends LightningElement {
    @api numeric;

    @api incremet(){
        this.numeric++;
    }

    connectedCallback(){
        this.incremet()
    }
}