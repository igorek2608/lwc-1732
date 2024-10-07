
export default function generateData(cases) {
    return cases.map((el, index) => {
        
        return {
            index: `${index + 1}`,
            caseNumber: `${el.CaseNumber}`,
            assignee: `${el.Owner_Name__c}`,
            priority: `${el.Priority}`,
            origin: `${el.Origin}`,
            CaseNumberUrl: `/${el.Id}`,
        };
    });
}