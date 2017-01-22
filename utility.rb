
=begin
This script contains a list of method that are required to do some operation like related with strings mainly.
It also contains method to read the file as a string.
    
Developed by  : Akshay Jangid Email:- "akshay.dce@gmail.com"
Modified date : 28th June, 2010

=end
  
  
  def get_file_as_string(filename)
    data = ''
    f = File.open(filename, "r") 
    f.each_line do |line|
                  data += line
                end
    f.close
    return data
  end

  def Upcase(file)
    if( subString_between(file,-1,1).upcase+subString_between(file,0,file.length) !=nil)  
      return subString_between(file,-1,1).upcase+subString_between(file,0,file.length)
    else
      return nil
    end
  end

  def subString_between(file,pos1,pos2)
    if(pos1!=nil and pos2!=nil)
      return (file[pos1+1,pos2-pos1-1])
      else
        return nil
    end
  end
  
  def subStringAfter(file,sym)
    pos=file.index(sym)
    len=file.length
    if(pos!=nil)
      return (file.slice(pos+1,len-pos-1))
    else
      return nil
    end
  end
 
 def subStringBefore(file,sym)
    if (sym.strip.length==0)
      return file
    end
    index = file.index(sym)
    if (index ==nil)
      return nil
    end
    return subString_between(file, -1,index)
  end
     
  def subString_between_strings_strict_last(file,string1,string2)
    pos2=file.rindex(string2)
    if(pos2 !=nil)
      pos1=file.rindex(string1,pos2-1)
    end
    if(pos1 !=nil and pos2 !=nil)
      return (subString_between(file,pos1+string1.length-1,pos2))
    else
      return nil
    end
  end

  def subString_between_strings_strict(file,string1,string2)
    if(string1 !=nil and string2 !=nil and file !=nil)
      pos1=file.index(string1)
      if(pos1 !=nil)
        pos2=file.index(string2,pos1+string1.length)
      end
      if(pos1 !=nil and pos2 !=nil)
        return (subString_between(file,pos1+string1.length-1,pos2))
      else
        return nil
      end
    end
  end
   

  def subString_between_strings_strict_all(file,string1,string2)
    array=Array.new
    temp=file
    for i in (0..file.length-1)
      if(temp==nil)
        break
      end
      if(subString_between_strings_strict(temp,string1,string2)==nil or subString_between_strings_strict(temp,string1,string2).strip.length==0)
      else
        array.push(subString_between_strings_strict(temp,string1,string2))
      end
      if((subString_between_strings_strict(temp,string1,string2))==nil)
        if(temp.index(string1) !=nil)
          p1=temp.index(string2,temp.index(string1))
        end
        if (p1!=nil)
          temp=temp.slice(p1+1,temp.length-1-p1-1)
        else
          break
        end
      else
        temp=subStringAfter(temp,subString_between_strings_strict(temp,string1,string2))
      end
    end
    return array
  end
  
 
 # The methods below are user specific
 
 
   
  def getAll_Index (file,sym)
    j=0
    all_index=Array.new
    for i in (0..(file.length)-1)
    if j<=((file.length.to_i)-1)
     all_index.push(file.index(sym,j))
      if(file.index(sym,j)==file.rindex(sym))
        break
      end
    end
    if j <(file.length)
      j=file.index(sym,j).to_i()+1
      else
        break
      end
    end
    return all_index
  end
 
  def get_minLength (ar1,ar2)
    if ar1.length>ar2.length
     value=ar2.length
    else
       value=ar1.length
    end
     
    return value
  end

  def slice_elements(file,file1_index_1,file1_index_2)
    l1=get_minLength(file1_index_1,file1_index_2)
    ele1=Array.new
    for i in (0..l1-1)
      temp1=file1_index_1[i].to_i
      temp2=file1_index_2[i].to_i
      ele1.push(file[temp1+1,temp2-temp1-1])
    end
    return ele1
  end

  def slice_values(file,file1_index_1,file1_index_2)
    l1=get_minLength(file1_index_1,file1_index_2)
    ele1=Array.new
    for i in (0..l1-2)
      temp1=file1_index_1[i+1].to_i
      temp2=file1_index_2[i].to_i
      ele1.push(file[temp2+1,temp1-temp2-1])
    end
    return ele1
  end

  def remove_null(arr)
    temp =Array.new
    for i in(0..(arr.length)-1)
      tem=arr[i]
      if(((tem).strip).length>0)
        temp.push(arr[i])
      end
    end
    return temp
  end

  def get_coresponding_element (file,value)
    v1=file.index('<',file.index(value))
    v2=file.index('>',file.index(value))
    return file[v1+1,v2-v1-1]
  end

  def get_final_element_list (file,list)
    temp1=Array.new
    for i in (0..list.length-1)
      temp1.push(get_coresponding_element(file,list[i]))
    end
    return temp1
  end
 
 
 
