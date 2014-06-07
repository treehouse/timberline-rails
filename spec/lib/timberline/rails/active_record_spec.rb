require 'spec_helper'

describe Timberline::Rails::ActiveRecord do
  describe "including in a class" do
    subject { SpecSupport::FakeRails::FakeModel }

    it "defines the timberline_queue method" do
      expect(subject).to respond_to :timberline_queue
    end

    it "defines the timberline_push method" do
      expect(subject).to respond_to :timberline_push
    end

    it "defines the delay_method method" do
      expect(subject).to respond_to :delay_method
    end
  end

  describe "using delay_method" do
    subject { SpecSupport::FakeRails::FakeModel.new }
    let(:method_name) { "some_method" }

    it "aliases the old method to synchronous_method_name" do
      expect(subject).to respond_to("synchronous_#{method_name}")
    end

    it "sets up a new method at timberline_method_name" do
      expect(subject).to respond_to("timberline_#{method_name}")
    end
  end

  describe "calling a delayed method" do
    subject { SpecSupport::FakeRails::FakeModel.new }
    let(:queue) { SpecSupport::FakeRails::FakeModel.instance_variable_get("@timberline_queue") }
    let(:expected_data) { { model_name: "SpecSupport::FakeRails::FakeModel", 
                            model_key: 1, 
                            method_name: :some_method } }

    it "pushes data about the method onto the queue" do
      expect(queue).to receive(:push).with(expected_data, {})
      subject.some_method
    end
  end
end
