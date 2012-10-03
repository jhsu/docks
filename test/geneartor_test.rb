require 'minitest_helper'

describe "Docks::Generator" do
  before do
    @ship = Docks::Ship.new('name' => 'google-qr', 'url' => 'http://github.com/jhsu/google-qr')

    docs_path = File.join(@ship.path, "doc")
    FileUtils.rm_rf(docs_path) if File.exists?(docs_path)
  end

  it "should be able to generate yard documentation" do
    result = Docks::Generator.yard(@ship)
    assert File.exists?(File.join(@ship.path, "doc")), result.inspect
  end
end
