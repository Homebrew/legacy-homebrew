def hw_model_output
  exe=Pathname.new(HOMEBREW_CACHE)+'hw.model'
  Kernel.system "gcc -Os #{File.dirname __FILE__}/hw.model.c -o #{exe}" unless exe.file?
  /(.*)(\d+),(\d+)/ =~ `#{exe}`
  yield $1, $2.to_i, $3.to_i
end

# http://support.apple.com/kb/HT3696
# http://www.cocoadev.com/index.pl?MacintoshModels
def hw_model
  hw_model_output do |model, major, minor|
    case model
      when "iMac" 
        if major <=4
          :core1
        elsif major <=8
          :core2
        else
          $unknown_hw_model=true
          :core2
        end

      when "MacBookAir"
        if major <= 1
          :core2
        else
          $unknown_hw_model=true
          :core2
        end

      when "MacBook"
        if major <= 1
          :core1
        elsif major <= 4
          :core2
        else
          $unknown_hw_model=true
          :core2
        end
      
      when "MacBookPro"
        if major <= 1
          :core1
        elsif major <= 5
          :core2
        else
          $unknown_hw_model=true
          :core2
        end
      
      when "Macmini" # Mac mini (Core Duo/Solo)
        if major <= 1
          :core
        else
          $unknown_hw_model=true
          :core
        end
        
      when "MacPro"
        if major <= 3
          :xeon
        else
          $unknown_hw_model=true
          :xeon
        end

      when "PowerBook", "PowerMac", "RackMac" then :ppc

      when "Xserve"
        if major <=2
          :xeon
        else
          $unknown_hw_model=true
          :xeon
        end
        
      when "ADP" then :dunno # Developer Transition Kit
      when "M43ADP" then :dunno # Development Mac Pro
      else :dunno
    end
  end
end
