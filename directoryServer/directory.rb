
class Directory
  attr_accessor :current_Location                                                
  def initialize()
    @WLANfile = 'WLAN Ad-hoc mode file'
    @LALAfile = 'lala file'
    @ResearchProposalfile = 'Research Proposal file'
    @RandomTestingFile = 'Random Testing File'
    
    @file1 = 'file1'
    @file2 = 'file2'
    @file3 = 'file3'
    @RandomFile = 'RandomFile'
    
    @cache = 0
    @FileServer = 1
    
    @file1_Location = @FileServer
    @file2_Location = @FileServer
    @file3_Location = @FileServer
    @RandomFile_Location = @FileServer
    
    @current_Location
    
  end
  
  def returnFile(file)
    case file
    when @WLANfile
      @current_Location = @file1_Location
      return @file1
    when @LALAfile
      @current_Location = @file2_Location
      return @file2
    when @ResearchProposalfile
      @current_Location = @file3_Location
      return @file3
    when @RandomTestingFile
      @current_Location = @RandomFile_Location
      return @RandomFile
    else
      return false 
    end                       
  end
  
  def updateFileLocationDirectory(file,server)
     case file
      when @file1 || @WLANfile 
        @file1_Location = server
      when @file2 || @LALAfile
        @file2_Location = server
      when @file3 || @ResearchProposalfile
        @file3_Location = server
      when @RandomFile || @RandomTestingFile 
        @RandomFile_Location = server
     end
  end
  
end
