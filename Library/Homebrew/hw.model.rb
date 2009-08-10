def hw_model_output
  require 'fileutils'
  HOMEBREW_CACHE.mkpath
  exe=HOMEBREW_CACHE+'hw.model'
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
        else
          $unknown_hw_model=true if major >8
          :core2
        end

      when "MacBookAir"
        $unknown_hw_model=true if major > 1
        :core2

      when "MacBook"
        if major <= 1
          :core1
        else
          $unknown_hw_model=true if major > 4
          :core2
        end
      
      when "MacBookPro"
        if major <= 1
          :core1
        else
          $unknown_hw_model=true if major > 5
          :core2
        end
      
      when "Macmini" # Mac mini (Core Duo/Solo)
        $unknown_hw_model=true if major > 1
        :core
        
      when "MacPro"
        $unknown_hw_model=true if major > 3
        # 'Xeon' is a marketing term, not a specific CPU:
        # http://en.wikipedia.org/wiki/Xeon
        # adamv says: I have a Mac Pro at work (MacPro4,1) and will try
        # some compiler options out.
        :xeon

      when "PowerBook", "PowerMac", "RackMac" then :ppc

      when "Xserve"
        $unknown_hw_model=true if major > 2
        :xeon
        
      when "ADP" then :dunno # Developer Transition Kit
      when "M43ADP" then :dunno # Development Mac Pro
      else :dunno
    end
  end
end
