require 'minitest_helper'

describe 'Docks::Ship' do
  let(:payload) { 
    JSON.parse(
      File.read(
        File.expand_path(File.join(File.dirname(__FILE__),"payload.json"))
    ))
  }

  it "should handle a payload" do
    assert Docks::Ship.receive(payload)
  end

  describe '#exists?' do
    before do
      @ship = Docks::Ship.receive(payload)
    end

    it "exists after receiving data" do
      assert @ship.exists?
    end

    it "generated docs" do
      assert File.exists?(File.join(@ship.path, "doc"))
    end
  end

end
