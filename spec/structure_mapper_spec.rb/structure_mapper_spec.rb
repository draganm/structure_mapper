require 'spec_helper'

describe StructureMapper::Array do
  describe :from_structure do
    context "when array has one String attribute" do
      let(:data) { ['value']}
      subject do
        Class.new do
          include StructureMapper::Array
          attribute a: String
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == 'value'
      end
    end

    context "when array has one Fixnum attribute" do
      let(:data) { [1]}
      subject do
        Class.new do
          include StructureMapper::Array
          attribute a: Fixnum
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == 1
      end

    end

    context "when array has one Boolean attribute" do
      let(:data) { [true]}
      subject do
        Class.new do
          include StructureMapper::Array
          attribute a: Boolean
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == true
      end

    end

    context "when array has one untyped array attribute" do
      let(:data) { [[1,2,3]]}
      subject do
        Class.new do
          include StructureMapper::Array
          attribute a: Boolean
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == [1,2,3]
      end

    end

    context "when array has one untyped hash attribute" do
      let(:data) { [{'a'=>'b'}]}
      subject do
        Class.new do
          include StructureMapper::Array
          attribute a: Boolean
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == {'a'=>'b'}
      end

    end


    context "when array has one mapped hash attribute" do
      let(:data) { [{'b'=>'c'}]}
      subject do
        inner = Class.new do
          include StructureMapper::Hash
          attribute b: String
        end
        Class.new do
          include StructureMapper::Array
          attribute a: inner
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.b.should == "c"
      end

    end


    context "when array has one mapped array attribute" do
      let(:data) { [['c']]}
      subject do
        inner = Class.new do
          include StructureMapper::Array
          attribute b: String
        end
        Class.new do
          include StructureMapper::Array
          attribute a: inner
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.b.should == "c"
      end

    end

  end
end

describe StructureMapper::Hash do

  describe :from_structure do

    context "when hash has one String attribute" do
      let(:data) { {'a' => 'b'}}
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: String
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == 'b'
      end
    end

    context "when hash has one Fixnum attribute" do
      let(:data) { {'a' => 1}}
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: Fixnum
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == 1
      end
    end

    context "when hash has one Array of strings attribute" do
      let(:data) { {'a' => ['one','two']}}
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: [String]
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == ['one','two']
      end
    end

    context "when hash has untyped hash attribute" do
      let(:data) { {'a' => {'one' => 'two'}}}
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: {}
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == {'one' => 'two'}
      end
    end

    context "when hash has untyped array attribute" do
      let(:data) { {'a' => ['one','two']}}
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: []
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == ['one','two']
      end
    end

    context "when hash has typed hash attribute" do
      let(:data) { {'a' => {'one' => 'two'}}}
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: {String => String}
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == {'one' => 'two'}
      end
    end

    context "when hash has typed array attribute" do
      let(:data) { {'a' => ['one','two']}}
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: [String]
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == ['one','two']
      end
    end

    context "when hash has boolean attribute" do
      let(:data) { {'a' => true} }
      subject do
        Class.new do
          include StructureMapper::Hash
          attribute a: Boolean
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.should == true
      end
    end


    context "when hash has mapped hash object attribute" do
      let(:data) { {'a' => {'b' => 'c'}}}
      subject do
        inner = Class.new do
          include StructureMapper::Hash
          attribute b: String
        end

        Class.new do
          include StructureMapper::Hash
          attribute a: inner
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.b.should == 'c'
      end
    end

    context "when hash has one mapped array object attribute" do
      let(:data) { {'a' => ['c']}}
      subject do
        inner = Class.new do
          include StructureMapper::Array
          attribute b: String
        end
        Class.new do
          include StructureMapper::Hash
          attribute a: inner
        end
      end
      it "should map the attribute to object's attribute" do
        subject.from_structure(data).a.b.should == "c"
      end

    end

  end

end
