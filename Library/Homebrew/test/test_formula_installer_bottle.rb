require "testing_env"
require "formula"
require "compat/formula_specialties"
require "formula_installer"
require "keg"
require "testball_bottle"

class InstallBottleTests < Homebrew::TestCase
	def temporary_bottle_install(formula)
		true # stub
	end

	def test_a_basic_bottle_install
		MacOS.expects(:has_apple_developer_tools?).returns(false)

		temporary_bottle_install(TestballBottle.new) do |f|
			assert true # stub
		end
	end
end
