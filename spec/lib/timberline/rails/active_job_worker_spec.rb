require 'spec_helper'

describe Timberline::Rails::ActiveJobWorker do
  subject do
    Timberline::Rails::ActiveJobWorker.new.tap do |worker|
      worker.instance_variable_set :@queue, queue
    end
  end
  let(:queue) { Timberline.queue("fake_queue") }
  let(:item) do
    queue.push({ job_class: "SpecSupport::FakeRails::FakeJob",
                 arguments: [1, 2, 3] })
    queue.pop
  end

  describe "#process_item" do
    it "uses ActiveJob to execute the item contents" do
      expect(ActiveJob::Base).to receive(:execute).with(item.contents)
      subject.process_item(item)
    end

    context "If the method raises an exception of its own" do
      before do
        allow_any_instance_of(SpecSupport::FakeRails::FakeJob).to receive(:perform) { raise "This doesn't work" }
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
