=begin
This script is used to invoke methods of a webservice.Use the "insert_data_ws(service_name,domain)" method to invoke a webservice.
First input the name of Webserive (service_name) and the Domain Name (domain) in which it is 
located(e.g. Voting,DIG,CRM).Then the program will show you the avialable method present in that webservice.Input the desired method 
for the operation exposed by webservice.Also all the request and response messages are saved in log.txt file in the
same folder.
    
Developed by  : Akshay Jangid Email:- "akshay.dce@gmail.com"
Modified date : 28th June, 2010

=end

#~ require 'class_webservices.rb'
    require 'class_webservices'
    require 'net/http'
    require 'rexml/document'
    include REXML


def insert_data_ws(url,method=nil)
    
    eval('@@obj='+'InvokeWS'+'.new('+"'"+url+"'"+').get_wsdl_obj')
    require 'web_utility.rb'
    
  begin
                            
          @@Service=getServiceName.strip
          loadConstans()
        insert_data_ws_full(@@Service,method)
        while (true)
            warn "\nWant to continue .....(choose y or n)?"
            val=gets.chomp
            if(val.to_s.upcase =='Y')
                  insert_data_ws_full(@@Service)
                  next
            else break
            end
          end
  rescue 
          
  else
                  
  ensure
      File.delete('default.rb')
      File.delete('defaultDriver.rb')
      File.delete('defaultMappingRegistry.rb')
      File.delete(@@Service+'Client.rb')
    end
      
      

      #~ varify_webservice_response(schema,method)
    
end

def write_log_file(method,service)
  
    start=Time.now
     
    @log=File.open('log.txt','a')
    @log.write('SOAP request and response for '+method+' method for '+service+' - '+start.to_datetime.to_s+"\n")
    
    #~ puts 'method inside logfile is = '+method
    file_req = File.open('SOAP_'+method+'_request.xml', "r")
    file_res = File.open('SOAP_'+method+'_response.xml', "r")
  
    @log.write("\nRequest message --- \n")
    while (line = file_req.gets)
      @log.write(line)
    end
    @log.write("\nResponse message --- \n")
    while (line = file_res.gets)
      @log.write(line)
    end
    @log.write("\n\n")
   @log.close
    file_req.close
    file_res.close
    warn "\nRequest and response are are captured and entered in log.txt\n"
 
  end
def varify_webservice_response(schema,method)
    file = File.open('SOAP_'+method+'_response.xml') #'SOAP_'+method+'_response.xml', "r"
    doc = Document.new(file)
    root = doc.root
           
    if (eval("(root.elements['soapenv:Body'].elements['soapenv:Fault']).to_s.strip.length") !=0 or eval("(root.elements['soapenv:Body'].elements['ns:"+schema+"Response'][1]).to_s.strip.length") ==0)
      #~ puts "\nIncorrect response"
      else
        #~ puts "\nWebservice executed successfully"
      
    end
    file.close
    
  end

def choose(method,schema,service)
  
  warn "\n"
    warn 'Choose the option for data insertion'
    warn '1. Keyboard'
    warn '2. CSV file'
    value1 = gets.chomp
    if(value1.to_s.strip.to_i ==1)
      r= setqueries(method,schema) # q.values are input XSD data type to corresponding methods
       return r
    end
    if(value1.to_s.strip.to_i ==2)
      r= setCSVqueries(method,schema,service) # q.values are input XSD data type to corresponding methods
      return r
    end
    
      warn "Incorrect choice, Enter Again.....\n"
      choose(method,schema,service)
    end
    
def insert_data_ws_full(service_name,method=nil)
    
    @@a_new=''
   
    @@Service=service_name.strip
    require 'web_utility.rb'
       
      
    q=getMethod_Input()
    #~ warn q.keys.length-1
    if(method ==nil)
          while (true)
                  warn "\nBelow is the list of available metohod in "+ @@Service.to_s+"\n"
                  printArray(q.keys.to_a)  # q.keys are methods names
                  warn "\n"
                  warn 'Choose the method you want to create the request for....'
                   value = gets.chomp
                   
                warn value.to_i 
                        if(value.to_i > (q.keys.length) or value.to_i <1)
                         warn 'incorrect choice, try again...'
                          next
                      else
                          method=q.keys[value.to_i-1]
                          schema=q.values[value.to_i-1]
                          break
                      end
                
                
                    
                 
            end
        else
        schema=q[method]
      end

    if(schema !="nil")
      r=choose(method,schema,@@Service)
      put=r[method]
       else
        r=""
        put =""
    end
    
    
    warn "\n"
       
    begin
   
#~ warn '@@obj.'+method+'('+put+')'
 #~ warn put
      eval('@@obj.'+method+'('+put+')')
    rescue 

    else
    ensure

    end
    warn "\n"
    write_log_file(method,@@Service)
    
 
      File.delete('SOAP_'+method.to_s+'_request.xml')
      File.delete('SOAP_'+method.to_s+'_response.xml')
    
  
          
  end


#~ insert_data_ws('http://webservices.amazon.com/AWSECommerceService/AWSECommerceService.wsdl','AWSECommerceService')  # uncomment this part to test it

#~ ws=InvokeWS.new('http://webservices.amazon.com/AWSECommerceService/AWSECommerceService.wsdl')

#~ BallotIngestionService MeetingIngestionService AccountAdminService VotingCustodianVService (Voting)
#~ UserProfileService ,Version(Crm)
#~ BallotIngestionDService (Dig)









































#~ require "xmlsimple"
#~ puts 'SOAP_'+'pushOEMBallots'+'_response.xml'
#~ data = XmlSimple.xml_in('SOAP_'+'pushOEMBallots'+'_response.xml',{ 'KeyAttr' => 'name' })
#~ p data

#~ SOAP_pushOEMBallots_response.xml

#~ puts "\n"
#~ puts data.values
#~ data['Result'].each do |item|
   #~ item.sort.each do |k, v|
      #~ if ["Title", "Url"].include? k
         #~ print "#{v[0]}" if k=="Title"
         #~ print " => #{v[0]}\n" if k=="Url"
      #~ end
   #~ end
#~ end









