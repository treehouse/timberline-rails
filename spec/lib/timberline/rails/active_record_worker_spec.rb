require 'spec_helper'

describe Timberline::Rails::ActiveRecordWorker do
  subject { Timberline::Rails::ActiveRecordWorker.new("fake_queue") }
  let(:queue) { Timberline.queue("fake_queue") }
  let(:item) do 
    queue.push({ model_name: "SpecSupport::FakeRails::FakeModel",
                 model_key: 1,
                 method_name: :some_method })
    queue.pop
  end

  describe "#process_item" do
    context "when handling a method that has been delayed by Timberline::Rails::ActiveRecord" do
      it "attempts to lookup the model" do
        expect(SpecSupport::FakeRails::FakeModel)
          .to receive(:find_by_id).with(1).and_call_original
        subject.process_item(item)
      end

      it "calls the appropriate method on the model" do
        expect_any_instance_of(SpecSupport::FakeRails::FakeModel)
          .to receive(:synchronous_some_method)
        subject.process_item(item)
      end
    end

    context "when handling a method that has not been delayed by Timberline::Rails::ActiveRecord" do
      before do
        item.contents["method_name"] = :some_other_method
      end

      it "attempts to lookup the model" do
        expect(SpecSupport::FakeRails::FakeModel)
          .to receive(:find_by_id).with(1).and_call_original
        subject.process_item(item)
      end

      it "calls the appropriate method on the model" do
        expect_any_instance_of(SpecSupport::FakeRails::FakeModel)
          .to receive(:some_other_method)
        subject.process_item(item)
      end
    end

    context "If the model can't be found" do
      before do
        allow(SpecSupport::FakeRails::FakeModel).to receive(:find_by_id) { nil }
      end

      it "retries the item" do
        expect(subject).to receive(:retry_item).with(item)
        subject.process_item(item)
      end

      it "gives the item a retry_reason" do
        expect { subject.process_item(item) }.to raise_error(Timberline::ItemRetried)
        expect(item.retry_reason).to include("Model not found")
      end
    end

    context "If the method doesn't exist on the model" do
      before do
        item.contents["method_name"] = "gibberish"
      end

      it "errors the item" do
        expect(subject).to receive(:error_item).with(item)
        subject.process_item(item)
      end

      it "gives the item an error_reason" do
        expect { subject.process_item(item) }.to raise_error(Timberline::ItemErrored)
        expect(item.error_reason).to include("Method not found")
      end
    end

    context "If the method raises an exception of its own" do
      before do
        allow_any_instance_of(SpecSupport::FakeRails::FakeModel).to receive(:synchronous_some_method) { raise "This doesn't work" }
      end

      it "errors the item" do
        expect(subject).to receive(:error_item).with(item)
        subject.process_item(item)
      end

      it "provides an error_reason" do
        expect { subject.process_item(item) }.to raise_error(Timberline::ItemErrored)
        expect(item.error_reason).to include("This doesn't work")
      end

      it "provides an error_backtrace" do
        expect { subject.process_item(item) }.to raise_error(Timberline::ItemErrored)
        expect(item.error_backtrace).to be_a Array
      end
    end
  end
end
