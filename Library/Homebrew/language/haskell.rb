module Language
  module Haskell
    # module for formulas using cabal-install as build tool
    module Cabal
      module ClassMethods
        def setup_ghc_compilers
          # Use llvm-gcc on Lion or below (same compiler used when building GHC).
          fails_with(:clang) if MacOS.version <= :lion
        end
      end

      def self.included(base)
        base.extend ClassMethods
      end

      def cabal_sandbox
        pwd = Pathname.pwd
        # force cabal to put its stuff here instead of the home directory by
        # pretending the home is here. This also avoid to deal with many options
        # to configure cabal. Note this is also useful with cabal sandbox to
        # avoid touching ~/.cabal
        home = ENV["HOME"]
        ENV["HOME"] = pwd

        # use cabal's sandbox feature if available
        cabal_version = `cabal --version`[/[0-9.]+/].split(".").collect(&:to_i)
        if (cabal_version <=> [1, 20]) > -1
          system "cabal", "sandbox", "init"
          cabal_sandbox_bin = pwd/".cabal-sandbox/bin"
        else
          # no or broken sandbox feature - just use the HOME trick
          cabal_sandbox_bin = pwd/".cabal/bin"
        end
        # cabal may build useful tools that should be found in the PATH
        mkdir_p cabal_sandbox_bin
        path = ENV["PATH"]
        ENV.prepend_path "PATH", cabal_sandbox_bin
        # update cabal package database
        system "cabal", "update"
        yield
        # restore the environment
        if (cabal_version <=> [1, 20]) > -1
          system "cabal", "sandbox", "delete"
        end
        ENV["HOME"] = home
        ENV["PATH"] = path
      end

      def cabal_install(*opts)
        system "cabal", "install", "--jobs=#{ENV.make_jobs}", *opts
      end

      # install the tools passed in parameter and remove the packages that where
      # used so they won't be in the way of the dependency solver for the main
      # package. The tools are installed sequentially in order to make possible
      # to install several tools that depends on each other
      def cabal_install_tools(*opts)
        opts.each { |t| cabal_install t }
        rm_rf Dir[".cabal*/*packages.conf.d/"]
      end

      # remove the development files from the lib directory. cabal-install should
      # be used instead to install haskell packages
      def cabal_clean_lib
        # a better approach may be needed here
        rm_rf lib
      end

      def install_cabal_package(args = [])
        cabal_sandbox do
          # the dependencies are built first and installed locally, and only the
          # current package is actually installed in the destination dir
          cabal_install "--only-dependencies", *args
          cabal_install "--prefix=#{prefix}", *args
        end
        cabal_clean_lib
      end
    end
  end
end
