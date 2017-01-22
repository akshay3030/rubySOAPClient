=begin
This script contains a list of utility method that are required to do operation related with WSDL,XML-Schema,Arrays and Hash mainly.

    
Developed by  : Akshay Jangid Email:- "akshay.dce@gmail.com"
Modified date : 28th June, 2010

=end


require 'rubygems'
require 'active_support'
  


require 'utility.rb'
#~ require 'lib/utility/utility.rb'

def getServiceName()
    y=nil
     basedir = "."
      cx= Dir.new(basedir).entries
      #~ warn cx
       cx.each do |x|
         if (x.to_s.include? "Client.rb")
           y=subStringBefore(x.to_s,'Client.rb')
          end
        end
    return y
end

  
def getPortName()
    require 'defaultDriver.rb'
    fs=get_file_as_string("defaultDriver.rb")
    port=subString_between_strings_strict(fs,'class','< ::')
    return  port.strip
end

class AccessMethod <Object::const_get(getPortName)
  def getPrivatemethod()
    return init_methods
  end
end
  
def getMethod_Input()
  result_hash=Hash.new
     temp=AccessMethod.new
     method= temp.getPrivatemethod()
    for i in (0..method.length-1)
      if(method[i][2][0][2][2].to_s !=nil and method[i][2][0][0].to_s=="in"  )
        result_hash[method[i][1].to_s]=method[i][2][0][2][2].to_s
        # method                      = InputDatatype
        else
           result_hash[method[i][1].to_s]='nil'
      end
    end 
  return result_hash
end
def loadConstans()
    require 'defaultMappingRegistry.rb'
    fs=get_file_as_string("defaultMappingRegistry.rb")
    val=subString_between_strings_strict(fs,'DefaultMappingRegistry','.register(')
    if(val !=nil)
      #~ warn val
      eval(val)
    end
    
  end
  

def getSchema(parent)
  #~ warn parent
    require 'defaultMappingRegistry.rb'
    fs=get_file_as_string("defaultMappingRegistry.rb")
 
    temp=subStringAfter(fs,':class => '+Upcase(parent.to_s)+',')
    schema=''+subString_between_strings_strict(temp,":schema_element =>","]
  )").to_s+']'
  #~ warn schema
    return  schema
end

def getType(schema)
      x= eval(getSchema(schema.strip))
      if (x !=nil)
      if ((x[0 ][1].to_a).length<2)
        type=2
        else
        type=1
      end
else
  type=2
end

    return type
end


def getElementList(schema,card)
  if(card ==nil)
  @@arr.push("["+Upcase(schema).to_s+"_BEGIN*]") 
  else
   @@arr.push("["+Upcase(schema).to_s+"_BEGIN]") 
  end   
 
    x= eval(getSchema(schema.strip)) # eval converts string to ruby script
    for i in (0..x.size-1)
             
                  if(@@type ==2)
                  tempp =x[i][1]
                 else
                   tempp=x[i][1][0]
                end
           
          
             
              if(
                (if(tempp !=nil) 
                  tempp.include? "[]" 
                end 
                       ) and !(tempp.include? "SOAP::") )
                       
                                  
                          getElementList(subStringBefore(tempp,'['), x[i][2][1])
                                 
              else
                
                if( if(tempp !=nil) 
                  tempp.include? "SOAP::"
                end  or  tempp ==nil)
                 
                  @@arr.push(x[i][0].to_s) 
                  else
                           
                    getElementList(tempp, x[i][2][1])
                   
                end
               
              end
       
     end
      if(card ==nil)
       @@arr.push("["+Upcase(schema).to_s+"_END*]") 
       else
          @@arr.push("["+Upcase(schema).to_s+"_END]") 
       end
       
  end



def createCSV(filename,schema)
  @@arr=Array.new 
  @@type=getType(schema)
   getElementList(schema,"not_nill")
 y=@@arr
  file = File.open(filename,'w')
    #~ file.write("["+schema.to_s+"_BEGIN]"+",\n")
    for i in (0..y.size-1)
      file.write(y[i]+",\n")
    end
     #~ file.write("["+schema.to_s+"_END]"+",\n")
    file.close
end




def readCSV(method,schema,service) #service,method
  store_key   =Array.new
  store_val   =Array.new
  store       =Array.new
  
 filename = service+'_'+method+'.csv'
 if(!File.exist?(filename))
    createCSV(filename,schema)
    warn 'Save the input values in newly created '+filename.to_s+ ' file'
    warn 'and then enter y to continue.'
    
     warn "\nWant to continue .....(choose y or n)?"
    value1 = gets.chomp
    if(value1.strip.upcase =='Y')
      readCSV(method,schema,service)
    else
        warn 'incorrect choice'
        exit
    end
      
 end
 file = File.new(filename, 'r')
 file.each_line("\n") do |row|
 columns = row.split(",")
 store_key.push(columns[0])
 store_val.push(columns[1])
  #~ break if file.lineno > 10
end
file.close
store.push(store_key)
store.push(store_val)
return store
end



def SetRequestFromCSV(method,schema,service)
    
     tmp=readCSV(method,schema,service)
     @x_new =""
     
    for i in (0..tmp[0].length-2)
           #~ warn tmp[0][i]
           val=subString_between_strings_strict(tmp[0][i],'[','_')
         #~ warn val
                if(tmp[0][i].include? "_BEGIN*]" and val !=nil)
                  @x_new <<('[')
                  
                  @x_new<<(val)
                  @x_new<<(".new(")
               
                  #~ check=tmp[0][i]
                  next
                 end
                    if(tmp[0][i].include? "_BEGIN]" and val !=nil)
                 #~ warn val
                  @x_new<<(val)
                  
                  @x_new<<(".new(")
               
                  #~ check=tmp[0][i]
                  next
                 end
                   
            
                if(tmp[0][i].include? "_END*]" and val !=nil)
                  @x_new<<(')')

                  @x_new<<('],')
                  
                  next
                end
             
                if(tmp[0][i].include? "_END]" and val !=nil)
                  @x_new<<('),')
          
                  
                  next
                end
              
                  @x_new<<(tmp[0][i].to_s) 
                   value = tmp[1][i]
                  @x_new<<(' = \''+value.to_s.strip+'\',')
               
                   
                 end
   
    local =(@x_new.gsub("][",","))
    
    #~ local1=local[0,local.length-1]
    
     #~ warn local.gsub(",)",")")+')'
    return local.gsub(",)",")")+')'
end

def setCSVqueries(method,schema,service)
    
    result_h = Hash.new()
    
      tmp=readCSV(method,schema,service)
    #~ cv=getMethod_Input()
    #~ @@x_new =""
     #keys are method ,values are xsdDataType
        result_h[method]=SetRequestFromCSV(method,schema,service).gsub(",)",")")
  
      #~ @@a_new=''
  
    return result_h
end


def SetRequestData(schema)
 
    @@arr=Array.new
#~ @@arr=nil    
@@type=getType(schema)
   getElementList(schema,"not_nill")
 y=@@arr
 
    
     @x_new =""
    for i in (0..y.length-2)
           #~ warn tmp[0][i]
           val=subString_between_strings_strict(y[i],'[','_')
         #~ warn val
                if(y[i].include? "_BEGIN*]" and val !=nil)
                  @x_new <<('[')
                  
                  @x_new<<(val)
                  @x_new<<(".new(")
               
                  #~ check=tmp[0][i]
                  next
                 end
                    if(y[i].include? "_BEGIN]" and val !=nil)
                 #~ warn val
                  @x_new<<(val)
                  
                  @x_new<<(".new(")
               
                  #~ check=tmp[0][i]
                  next
                 end
                   
            
                if(y[i].include? "_END*]" and val !=nil)
                  @x_new<<(')')

                  @x_new<<('],')
                  
                  next
                end
             
                if(y[i].include? "_END]" and val !=nil)
                  @x_new<<('),')
          
                  
                  next
                end
              
                  @x_new<<(y[i].to_s) 
                    warn 'enter the value for '+y[i].to_s
                    value = gets.chomp
                    @x_new<<(' = \''+value.to_s.strip+'\',')
                                  
                 end
   
    local =(@x_new.gsub("][",","))
    
    #~ local1=local[0,local.length-1]
    
     #~ warn local.gsub(",)",")")+')'
    return local.gsub(",)",")")+')'
end


def setqueries(method,schema)
   #~ loadConstans()
   @@arr=Array.new 
    result_h = Hash.new()
    result_h[method]=SetRequestData(schema).gsub(",)",")")
    return result_h
end
  
def checkMethod(method)
    if(getAllqueries.keys.include? value.strip)
    else
          warn 'Incorrect Method name'
          warn 'try again ?'
          value = gets.chomp
          if(value.strip[0].upcase=='Y')
            checkMethod(method)
          else
            warn 'Program terminated..'
            break
          end
    end
  end
 
def printArray (ar)
    for i in (0..ar.length-1)
        print (i+1).to_s+". "
        print ar[i]
        print "\n"
    end
end



















#~ def SetRequestData(schema)
 
    #~ if(getSchema(schema.strip) !='[')
        
        #~ x= eval(getSchema(schema.strip)) #eval converts string to ruby script
       
    #~ else
        #~ x=[]
    #~ end
      
    #~ @@a_new<<(Upcase(schema))
    #~ @@a_new<<(".new(")
    #~ for i in (0..x.size-1)
        
              #~ if(x[i][1][0].to_s =="nil" or 
                #~ if(x[i][1][0] !=nil) 
                  #~ x[i][1][0].include? "[]" 
                #~ end                and !(x[i][1][0].include? "SOAP::"))
                
                #~ @@a_new<<('[')
                #~ SetRequestData(subStringBefore(x[i][1][0],'['))
                #~ @@a_new<<('],')
                               
              #~ else
              
                
                #~ if(x[i][1][0].include? "SOAP::" )
                #~ @@a_new<<(x[i][0].to_s) 
                #~ warn 'enter the value for '+x[i][0].to_s
                #~ value = gets.chomp
                #~ @@a_new<<(' = \''+value.to_s.strip+'\',')
                  #~ else
                    #~ getElementList(x[i][1][0])
                #~ end
                     
                
              #~ end
                
            
    #~ end
    #~ @@a_new<<(')')
    #~ return @@a_new
#~ end





#~ def SetRequestFromCSV(method,schema,service)
     #~ if(getSchema(schema.strip) !='[')
        #~ x= eval(getSchema(schema.strip)) #eval converts string to ruby script
    #~ else
        #~ x=[]
    #~ end
    #~ tmp=readCSV(method,schema,service)
    #~ puts "the length of csv is "+(tmp.length).to_s
    #~ exit
    #~ @@a_new<<(Upcase(schema))
    #~ @@a_new<<(".new(")
    #~ for i in (0..x.size-1)
        
              #~ if(x[i][1].to_s =="nil" or 
                #~ if(x[i][1] !=nil) 
                  #~ x[i][1].include? "[]" 
                #~ end                )
                
                #~ @@a_new<<('[')
                #~ SetRequestFromCSV(method,subStringBefore(x[i][1],'['),service)
                #~ @@a_new<<('],')
                               
              #~ else
                #~ @@a_new<<(x[i][0].to_s) 
              
                #~ value = tmp[(x[i][0].to_s).upcase]
                #~ @@a_new<<(' = \''+value.to_s.strip+'\',')
              #~ end
       
    #~ end
    #~ @@a_new<<(')')
    #~ return @@a_new
#~ end










#~ def getAllqueries()
    #~ result_h = Hash.new()
    #~ cv=getMethod_Input()
    #~ for i in (0..cv.keys.length-1)
      #~ result_h[cv.keys[i]]=CreateRequestData(cv.keys[i]).gsub(",)",")")
      #~ @@a_new=''
    #~ end
    #~ return result_h
#~ end

#~ def CreateRequestData(root)
    #~ x= eval(getSchema(root))
    #~ @@a_new<<(Upcase(root))
    #~ @@a_new<<(".new(")
    #~ for i in (0..x.size-1)
        
              #~ if(x[i][1].to_s =="nil" or 
                #~ if(x[i][1] !=nil) 
                  #~ x[i][1].include? "[]" 
                #~ end                    )
                
                #~ @@a_new<<('[')
                #~ CreateRequestData(subStringBefore(x[i][1],'['))
                #~ @@a_new<<('],')
                               
              #~ else
                #~ @@a_new<<(x[i][0].to_s) 
                
                #~ @@a_new<<(' = nil,')
              #~ end
       
    #~ end
    #~ @@a_new<<(')')
    #~ return @@a_new
#~ end