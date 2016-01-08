require "os/mac/version"

module OS
  module Mac
    class SDK
      attr_reader :version, :path

      def initialize(version, path)
        @version = OS::Mac::Version.new version
        @path = Pathname.new(path)
      end
    end

    class SDKLocator
      class NoSDKError < StandardError; end

      def sdk_for(v)
        path = sdk_paths[v]
        raise NoSDKError if path.nil?

        SDK.new v, path
      end

      def latest_sdk
        return if sdk_paths.empty?

        v, path = sdk_paths.max {|a, b| OS::Mac::Version.new(a[0]) <=> OS::Mac::Version.new(b[0])}
        SDK.new v, path
      end

      private

      def sdk_paths
        @sdk_paths ||= begin
          # Xcode.prefix is pretty smart, so let's look inside to find the sdk
          sdk_prefix = "#{Xcode.prefix}/Platforms/MacOSX.platform/Developer/SDKs"
          # Xcode < 4.3 style
          sdk_prefix = "/Developer/SDKs" unless File.directory? sdk_prefix
          # Finally query Xcode itself (this is slow, so check it last)
          sdk_prefix = File.join(Utils.popen_read(OS::Mac.locate("xcrun"), "--show-sdk-platform-path").chomp, "Developer", "SDKs") unless File.directory? sdk_prefix

          # Bail out if there is no SDK prefix at all
          if !File.directory? sdk_prefix
            {}
          else
            paths = {}

            Dir[File.join(sdk_prefix, "MacOSX*.sdk")].each do |sdk_path|
              version = sdk_path[/MacOSX(\d+\.\d+)u?.sdk$/, 1]
              paths[version] = sdk_path unless version.nil?
            end

            paths
          end
        end
      end
    end
  end
end
