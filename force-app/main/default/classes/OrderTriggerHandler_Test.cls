@isTest
private class OrderTriggerHandler_Test {
	
	@isTest static void test_method_one() {

		Account acc = new Account(
			Name = 'testAccount'
			);
		insert acc;

		PriceBook2 pb = New PriceBook2(Id = test.getStandardPricebookId(), isActive = true);
		update pb;
		List<Opportunity> oppList = new List<Opportunity>();
		Opportunity opp = new Opportunity(
			Name = 'testOpp',
			AccountId = acc.Id,
			CloseDate = System.TODAY(),
			StageName = 'Closed Won',
			Pricebook2Id = pb.Id
			);
		oppList.add(opp);
		Opportunity opp1 = new Opportunity(
			Name = 'testOpp1',
			AccountId = acc.Id,
			CloseDate = System.TODAY(),
			StageName = 'Closed Won',
			Pricebook2Id = pb.Id
			);
		oppList.add(opp1);
		insert oppList;

		Product2 prd1 = new Product2 (Name='Test Product Entry 1', Family='Best Pricebook ever', isActive = true);
        insert prd1; 

        Product2 prd2 = new Product2 (Name='Test Product Entry 2', Family='Best Pricebook ever', isActive = true);
        insert prd2; 

		PricebookEntry pbe = new PricebookEntry(Pricebook2Id = test.getStandardPricebookId(), Product2Id = prd1.Id, UnitPrice = 1000, isActive = true);
		insert pbe;

		PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id = test.getStandardPricebookId(), Product2Id = prd2.Id, UnitPrice = 100, isActive = true);
		insert pbe1;

		OpportunityLineItem oli = new OpportunityLineItem(
			Product2Id = prd1.Id,
			Quantity = 1,
			UnitPrice = 1000,
			PricebookEntryId = pbe.Id,
			OpportunityId = opp.Id
			);
		insert oli;

		OpportunityLineItem oli1 = new OpportunityLineItem(
			Product2Id = prd2.Id,
			Quantity = 1,
			UnitPrice = 100,
			PricebookEntryId = pbe1.Id,
			OpportunityId = opp.Id
			);
		insert oli1;

		List<Order> orderList = new List<Order>();
		Order order1 = new Order(
			AccountId = acc.Id,
			OpportunityId = opp.Id,
			Status = 'Draft',
			EffectiveDate = System.TODAY(),
			Copy_Opportunity_Product_Lines__c = true
			);
		orderList.add(order1);
		Order order2 = new Order(
			AccountId = acc.Id,
			OpportunityId = opp1.Id,
			Status = 'Draft',
			EffectiveDate = System.TODAY(),
			Copy_Opportunity_Product_Lines__c = true
			);
		orderList.add(order2);

		insert orderList;
	}
	
}