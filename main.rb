=begin
This is main file.



You can achieve follwing by running this tool:-

1.  Access a webservice
2.  Write the request and response into log.txt file in the root directory.
3.  you can insert the data to webservice operation eithe using command screen or Using a csv file
    which will be automatically created ,if not present already.
4.  For entering values into CSV for multiple cardinality elements ,remove the star in between the repetetion:-
    see the "AWSECommerceService_cartAdd.csv" & "AWSECommerceService_itemSearch.csv" for more details.

      Example for entering multiple cardinality values  
      [CartAddRequest::Items::Item::MetaData_BEGIN*]
      key
      value
      [CartAddRequest::Items::Item::MetaData_END]
      [CartAddRequest::Items::Item::MetaData_BEGIN]
      key
      value
      [CartAddRequest::Items::Item::MetaData_END*]

5. Never name any of your ruby script with work "Client.rb". It is a bug in the current tool.
    if any file with name containing world "Client.rb" is present in the root, It might behave wierdly.

6.  Note that method insert_data_ws(url,method) is also overloaded for insert_data_ws(url)
7. If you find anybug, please look into web_utility.rb file inside getType(schema),getElementList(schema,card) method

8.  Hope that you will enjoy the examples i have commented below
    
Copyrights :- None    
    
Developed by  : Akshay Jangid ,Email:- "akshay.dce@gmail.com"
Modified date : 16 July June, 2010

=end

require 'webservices_client.rb'

# insert_data_ws(url,method=nil)   # Method prototype

insert_data_ws('http://webservices.amazon.com/AWSECommerceService/AWSECommerceService.wsdl')

# uncomment this part to test it   
#~ insert_data_ws('http://webservices.amazon.com/AWSECommerceService/AWSECommerceService.wsdl','help')  # uncomment this part to test it   

#~ insert_data_ws('http://w3schools.com/webservices/tempconvert.asmx?WSDL')

#~ insert_data_ws('http://www.webservicex.net/WeatherForecast.asmx?WSDL')



#~ insert_data_ws('http://cam-px-i-app01:9333/axis2/services/BallotIngestionService?wsdl')