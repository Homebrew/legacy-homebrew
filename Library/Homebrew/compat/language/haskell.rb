module Language
  module Haskell
    module Cabal
      def cabal_clean_lib
        # avoid installing any Haskell libraries, as a matter of policy
        rm_rf lib
      end
    end
  end
end
