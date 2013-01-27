require 'formula'
class Gmp < Formula
                                                                             ###
 homepage 'http://gmplib.org/' # <-: GNU mirrors no longer host GMP releases:  #
 #  "The gmplib.org site now is the sole source for current GMP releases."     #
 url 'ftp://ftp.gmplib.org/pub/gmp-5.1.0/gmp-5.1.0.tar.bz2'# I found a mirror  #
 mirror 'http://fossies.org/unix/misc/gmp-5.1.0.tar.bz2' # <--: here for now.  #
 sha256 'dfd9aba98fe5caa54a715b4584c7d45eb0ee0c8be9a3181164ad2fad5eefc796'     #

 ###
 # Passing any of the following arguments to configure *will* cause failures:
 # enable-nails , enable-fat, enable-profiling=prof|gprof, enable-assert
 # Those options exposed below are to make debugging easier. for easy debugging. 
 # Generally, don't touch. The same goes for anything unlisted.

 option '32-bit', 'Manually specify 32-bit ABI'                              ###
 option 'enable-assert', 'Enable assertion checking. Not reccommended.'        #
 option 'disable-cxx', 'Disable C++ support.'                                  #
 option 'disable-assembly', 'Disable assembly code optimization. Much slower.' #
 option 'disable-fft', 'Disable fast Fourier transforms for multiplication.'   #
 option 'disable-shared', 'Do not build dylibs.'                               #
 option 'enable-static', 'Build static libraries (as well). No need usually.'  #
 option 'enable-old-fft-full', 'Full of old farts. If thats what you want.'    #

 def install
  args = ["--prefix=#{prefix}"] 
  args << '--enable-cxx'      unless build.include? 'disable-cxx'
  args << '--disable-static'  unless build.include? 'enable-static'

  args << '--disable-shared'      if build.include? 'disable-shared'
  args << '--enable-assert'       if build.include? 'enable-assert'
  args << '--enable-old-fft-full' if build.include? 'enable-old-fft-full'
  args << '--disable-assembly'    if build.include? 'disable-assembly'
  args << '--disable-fft'         if build.include? 'disable-fft' 
  
  ###
  # The previous issues listed herein should't occur provided that the following
  # strictures are adhered to: first, do not try to optimize. The whole idea
  # behind GMP is to help on big hard math stuff by using the strengths of your
  # individual CPU, with as much of the C implementation replaced with assembly
  # code as possible. It needs to be able to accurately recognize your platform.
  # So no flags, except: you MUST tell the toolchain the proper architecture to
  # match the target ABI.

  ###
  # We'll then bake in -m32 where needed the second time, roll our own fat
  # binary with lipo. A Note: specifying "--build=none-apple-darwin" as per
  # the previous configuration is precicly the opposite of the goal here
  # exactly *not* what we want to do; it clobbers any possible optimizations
  # and, in the case of "none", literally forces it to use *only* C code.

  ENV.deparallelize # is, unfortuately, needed. The problem is somewhere between
                    # autoenv and libtool, though who's but it is, hard to say.
                    # It chokes up at link time and complains about a duplicate
                    # directory. But this is a good enough workaround.

  if MacOS.prefer_64_bit? && !build.build_32_bit?

     ENV.m64; ENV.append 'ABI', '64'

     system './configure', *args
     system 'make'
     system 'make -C tune speed'
     system "make am--refresh"
     system './configure', *args
     system 'make'
     system 'make check'
     system 'make install'

     system 'mv', "#{prefix}", "#{Pathname.pwd}/64"
     system 'make distclean'
     
     ENV.delete 'ABI'                                                        end

   ENV.m32
   ENV.append 'ABI', '32'

   system './configure', *args
   system 'make'
   system 'make -C tune speed'
   system 'make am--refresh'
   system './configure', *args
   system 'make'
   system 'make check'
   system 'make install'

   unless build.build_32_bit? || !MacOS.prefer_64_bit?
   
    system 'lipo',   "-create", "#{prefix}/lib/libgmp.10.dylib",
                                "#{Pathname.pwd}/64/lib/libgmp.10.dylib",
                     "-output", "#{prefix}/lib/libgmp.10.dylib"
    
    system 'lipo',   '-create', "#{prefix}/lib/libgmpxx.4.dylib",
                                "#{Pathname.pwd}/64/lib/libgmpxx.4.dylib",
                     '-output', "#{prefix}/lib/libgmpxx.4.dylib"
                          
    if build.include? 'enable-static'
     system 'lipo',  '-create', "#{prefix}/lib/libgmp.a",
                                "#{Pathname.pwd}/64/lib/libgmp.a",
                     '-output', "#{prefix}/lib/libgmp.a"
    
     system 'lipo',  '-create', "#{prefix}/lib/libgmpxx.a",
                                "#{Pathname.pwd}/64/lib/libgmpxx.a",
                     '-output', "#{prefix}/lib/libgmpxx.a"                   end
                                                                             end
   if build.include? 'enable-static'
      system 'strip', '-x',     "#{prefix}/lib/libgmp.a",
                                "#{prefix}/lib/libgmpxx.a"
      system 'lipo', '-info',   "#{prefix}/lib/libgmp.a"
      system 'lipo', '-info',   "#{prefix}/lib/libgmpxx.a"
                                                                             end
      system 'strip', '-x',     "#{prefix}/lib/libgmp.10.dylib",
                                "#{prefix}/lib/libgmpxx.4.dylib"
      system 'lipo', '-info',   "#{prefix}/lib/libgmp.10.dylib"
      system 'lipo', '-info',   "#{prefix}/lib/libgmpxx.4.dylib"
end                                                                          end
