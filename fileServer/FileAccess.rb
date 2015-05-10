class FileAccess                                               
  def initialize()                  
    @fileLines = Array.new
  end
  
  def availableFiles
    return Dir["**/*.txt"]
  end
  
  def download(desiredFile)
    @fileLines = Array.new
    if File.file?("#{desiredFile}.txt")
      count = 0
      f = File.open("#{desiredFile}.txt", "r")
      f.each_line do |line|
        @fileLines[count] = line
        count += 1
      end      
      f.close 
      return @fileLines
    else
      return false       
    end
  end
  
  def uploadSection(uploadContent,fileName,section)
    originalFile = download(fileName)
    numOfLines = originalFile.length
    count = 0
    orginalcount = 0 
    newFile = Array.new
    while numOfLines > orginalcount
    puts originalFile[orginalcount] 
      if originalFile[orginalcount].include? section
        newFile[count] = originalFile[orginalcount]
        count += 1
        orginalcount += 1
        numOfLinesUpload = uploadContent.length
        countUpload = 0 
        while numOfLinesUpload > countUpload
          newFile[count] = uploadContent[countUpload] + "\n"
          count += 1
          countUpload += 1
        end
      else
        if !originalFile[orginalcount].empty?
          newFile[count] = originalFile[orginalcount]
          count += 1
          orginalcount += 1
        end
      end
    end
    File.open("#{fileName}.txt", 'w') do |f|
      numOfLines = newFile.length
      count = 0 
      while numOfLines > count
        f << "#{newFile[count]}"
        count += 1
      end
    end
  end

  def uploadEntireDocument(uploadContent,fileName)
    File.open("#{fileName}.txt", 'a+') do |f|
      numOfLines = uploadContent.length
      count = 0 
      while numOfLines > count
        f << "#{uploadContent[count]}\n"
        count += 1
      end
    end
  end
  
  def upload(uploadContent,fileName,section)   
     if section != "ENTIRE_DOCUMENT"
        uploadSection(uploadContent,fileName,section)
     else
        uploadEntireDocument(uploadContent,fileName)
     end
    return download(fileName)  
  end
end
