public without sharing class OrderTriggerHandler {
    public static void AssignOrderLineItems (List<Order> triggerNew) {
        Set<Id> opptySetId = new Set<Id>();
        Set<Order> orderUpdate = new Set<Order>();
        List<Order> orderToUpdate = new List<Order>();
        List<OrderItem> itemToInsert = new List<OrderItem>();

        for (Order o: triggerNew) {
            if (o.Id != null && o.OpportunityId != null && o.Copy_Opportunity_Product_Lines__c == true) {
                opptySetId.add(o.OpportunityId);
            }
        }
        List<OpportunityLineItem> olis = [SELECT Id, Product2Id, Quantity, UnitPrice, PricebookEntryId, Opportunity.Pricebook2Id, OpportunityId FROM OpportunityLineItem WHERE OpportunityId IN: opptySetId];
        

        if (olis.isEmpty() == false) {
            Map<Id, List<OpportunityLineItem>> bulkifyList = new Map<Id, List<OpportunityLineItem>>();
            for (OpportunityLineItem opplis: olis) {
                if (bulkifyList.containsKey(opplis.OpportunityId)) {
                    List<OpportunityLineItem> lstOpp = bulkifyList.get(opplis.OpportunityId);
                    lstOpp.add(opplis);
                } else {
                        List<OpportunityLineItem> lstOpp = new List<OpportunityLineItem>();
                        lstOpp.add(opplis);
                        bulkifyList.put(opplis.OpportunityId, lstOpp);
                }
            }




            if (bulkifyList.isEmpty() == false) {
                for (Order o: triggerNew) {
                    if (o.OpportunityId != null && bulkifyList.containsKey(o.OpportunityId)) {
                        List<OpportunityLineItem> lstOpportunityLine = bulkifyList.get(o.OpportunityId);

                        for (OpportunityLineItem ol: lstOpportunityLine) {
                            orderUpdate.add(new order(Id=o.Id, Pricebook2Id=ol.Opportunity.Pricebook2Id));
                            OrderItem oItem = new OrderItem(
                                OrderId = o.Id,
                                Product2Id = ol.Product2Id,
                                Quantity = ol.Quantity,
                                UnitPrice = ol.UnitPrice, 
                                PricebookEntryId = ol.PricebookEntryId);
                            itemToInsert.add(oItem);
                        }

                    }
                }
            }
            orderToUpdate.addAll(orderUpdate);
            update orderToUpdate;
            insert itemToInsert;
        }
    }

    }