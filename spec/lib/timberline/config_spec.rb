require 'spec_helper'

describe Timberline::Config do
  context "When there is a valid config file" do
    before { SpecSupport::FakeRails.create_fake_env }
    after  { SpecSupport::FakeRails.destroy_fake_env }

    it "does not delegate to the original Timberline constructor" do
      config = Timberline::Config.new
      expect(config).not_to receive(:non_rails_initialize)
      config.rails_initialize
    end

    context "loading data from the config file:" do
      subject { Timberline::Config.new }

      it "host" do
        expect(subject.host).to eq("localhost")
      end

      it "port" do
        expect(subject.port).to eq(12345)
      end

      it "timeout" do
        expect(subject.timeout).to eq(10)
      end

      it "password" do
        expect(subject.password).to eq("foo")
      end

      it "database" do
        expect(subject.database).to eq(3)
      end

      it "namespace" do
        expect(subject.namespace).to eq("treecurve")
      end
    end
  end  

  context "When there is not a valid config file" do
    before { SpecSupport::FakeRails.create_fake_env_without_config }
    after  { SpecSupport::FakeRails.destroy_fake_env }

    it "delegates to the original Timberline constructor" do
      config = Timberline::Config.new
      expect(config).to receive(:non_rails_initialize)
      config.rails_initialize
    end
  end
end
