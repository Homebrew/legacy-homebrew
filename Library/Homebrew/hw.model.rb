#  Copyright 2009 Max Howell and other contributors.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
#  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
#  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
#  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
#  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
#  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# The output of the command is in the form of: `MacBook2,1'
# This yields: "MacBook", 2, 1
def hw_model_output
  model=`/usr/sbin/sysctl hw.model`.match /hw.model: (\w+)(\d+),(\d+)/
  yield model[1], model[2].to_i, model[3].to_i
end

# http://support.apple.com/kb/HT3696
# http://www.cocoadev.com/index.pl?MacintoshModels
def hw_model
  hw_model_output do |model, major, minor|
    case model
      when "iMac"
        if major <= 4
          :core1
        else
          $unknown_hw_model=true if major > 8
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
