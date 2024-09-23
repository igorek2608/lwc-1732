import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';


export default class CaseNavigation extends NavigationMixin(LightningElement) {
    @api cs;

    navigateToCasePage(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.cs.Id,
                objectApiName: 'Case',
                actionName: 'view'
            }
        });
    }
}