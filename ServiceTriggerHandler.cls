public class ServiceTriggerHandler {
    
    public static void onBefore(List<Service_Per_Truck__c> newServiceList )
    {
        List<Product2> ListOfProducts = new List<Product2>();
        Map< string, Double> mapOfProductandPrice = new Map<String, Double>();
        List<PricebookEntry> ListOfPriceBookEntry = [Select Product2Id, UnitPrice, UseStandardPrice from PricebookEntry where UseStandardPrice =true];
        if( ListOfPriceBookEntry != null && ListOfPriceBookEntry != null  )
            for(PricebookEntry eachPrice : ListOfPriceBookEntry)
        {
            mapOfProductandPrice.put(eachPrice.Product2Id, eachPrice.UnitPrice);
        }
        if(newServiceList != null && newServiceList.size() > 0)
        {
            for(Service_Per_Truck__c each : newServiceList )
            {
                list<Asset> listOfAssets = [Select Product2Id from asset where id=:each.Asset__c limit 1];
                if( listOfAssets != null && listOfAssets[0] != null && listOfAssets.size() > 0)
                {
                    Double TruckPrice = mapOfProductandPrice.get(listOfAssets[0].Product2Id);
                    //system.debug('---mapOfProductandPrice--->'+mapOfProductandPrice);
                    //system.debug('---each.Asset__c.Product2Id--->'+each.Asset__r.Product2Id);
                    if( TruckPrice != null )
                        each.Service_Cost__c= ((10 * TruckPrice) / 100);   
                }
            }
        }
    }
}