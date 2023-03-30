public with sharing class MyTeamOrdersController {
    public decimal ShowTotalOrdersNetAmount{
        get{
			AggregateResult groupedResults = 
            [SELECT SUM(NetAmount__c) total 
            FROM Order WHERE Status = 'Ordered'];
            
			return (decimal)groupedResults.get('total');
        }
        set;
    }
}