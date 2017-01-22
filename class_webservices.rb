=begin
This script contains a list of class structures for WSDL reading from url and initializing various fields in it.

Developed by  : Akshay Jangid Email:- "akshay.dce@gmail.com"
Modified date : 28th June, 2010

=end



#~ require '../utility/utility.rb'
require 'utility.rb'



class WebServices
  @@url=nil
  def initialize(url)
       
      @@url=url
 
     File.open("temp.bat", 'w') {|f| f.write("wsdl2ruby.rb --wsdl "+@@url.to_s+" --type client --force")}
    system("temp.bat")
    
    require 'defaultDriver.rb'
    #~  'default.rb'
    endpoint_url = ARGV.shift
    port_class=subString_between_strings_strict(get_file_as_string("defaultDriver.rb"),'class','< ::')
    @@obj=Object::const_get(port_class.strip).new(endpoint_url) #generate class at runtime from string class name
    #@@obj = BallotIngestionServicePortType.new(endpoint_url)
    @@obj.wiredump_dev = STDERR
    @@obj.wiredump_dev = STDOUT 
    @@obj.wiredump_file_base = "SOAP"
    File.delete('temp.bat')
  end
  def get_wsdl_obj()
        #~ obj.pushBallots(PushBallots.new("1", [Ballot.new("", "S52", 200000025, 0, "","300046930563", 48372, "01FL100000000000000",496, "2010-06-10T18:00:00.000Z", "", "","", "", 533627,1,0,"","",1,1,"2767165","","2010-03-31T16:00:00.000Z","","","","BNP Paribas France (FR)",0,166.00000,89.00000,"2010-06-06T18:00:00.000Z")]))
    return @@obj
  end
end


class InvokeWS < WebServices
  def initialize(url)
      super(url)
  end
end
#~ UserProfileService
#~ BallotIngestionService
#~ test=WSDLRuby.new('cam-px-i-app01','9333','/axis2/services/','BallotIngestionService')
#~ puts test.getURL
#~ test.loadDefaultDriver()





