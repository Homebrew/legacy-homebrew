require "testing_env"
require "requirements/mpi_requirement"

class MPIRequirementTests < Homebrew::TestCase
  def test_initialize_untangles_tags_and_wrapper_symbols
    wrappers = [:cc, :cxx, :f77]
    tags = [:optional, "some-other-tag"]
    dep = MPIRequirement.new(*wrappers + tags)
    assert_equal wrappers, dep.lang_list
    assert_equal tags, dep.tags
  end
end
