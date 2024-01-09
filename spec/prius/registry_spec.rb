# frozen_string_literal: true

require "prius/registry"

RSpec.describe Prius::Registry do
  let(:env) do
    {
      "NAME" => "Harry",
      "AGE" => "25",
      "ALIVE" => "Yes",
      "BORN" => "2022-09-02",
      "INVALID_DATE" => "2022-02-99",
    }
  end
  let(:registry) { described_class.new(env) }

  describe "#load" do
    context "given an invalid option" do
      it "raises an error" do
        expect { registry.load(:age, unsupported_option: :foo) }.
          to raise_error(ArgumentError)
      end
    end

    context "given a name that's present in the environment" do
      it "doesn't blow up" do
        expect { registry.load(:name) }.to_not raise_error
      end
    end

    context "given a name that's not present in the environment" do
      it "blows up" do
        expect { registry.load(:slogan) }.
          to raise_error(Prius::MissingValueError)
      end

      context "when required is false" do
        it "doesn't blow up" do
          expect { registry.load(:slogan, required: false) }.to_not raise_error
        end
      end
    end

    context "given an invalid type" do
      it "blows up" do
        expect { registry.load(:name, type: :lightsabre) }.
          to raise_error(ArgumentError)
      end
    end

    context "when specifying :int as the type" do
      context "given a integer value" do
        it "doesn't blow up" do
          expect { registry.load(:age, type: :int) }.to_not raise_error
        end

        it "stores an int" do
          registry.load(:age, type: :int)
          expect(registry.get(:age)).to be_a(Integer)
        end
      end

      context "given a non-integer value" do
        it "blows up" do
          expect { registry.load(:name, type: :int) }.
            to raise_error(Prius::TypeMismatchError)
        end
      end
    end

    context "when specifying :bool as the type" do
      context "given a boolean value" do
        it "doesn't blow up" do
          expect { registry.load(:alive, type: :bool) }.to_not raise_error
        end

        it "stores an boolean" do
          registry.load(:alive, type: :bool)
          expect(registry.get(:alive)).to be_a(TrueClass)
        end
      end

      context "given a non-boolean value" do
        it "blows up" do
          expect { registry.load(:name, type: :bool) }.
            to raise_error(Prius::TypeMismatchError)
        end
      end
    end

    context "when specifying :date as the type" do
      context "given a date value" do
        it "doesn't blow up" do
          expect { registry.load(:born, type: :date) }.to_not raise_error
        end

        it "stores a date" do
          registry.load(:born, type: :date)
          expect(registry.get(:born)).to be_a(Date)
          expect(registry.get(:born)).to eq(Date.parse(env["BORN"]))
        end
      end

      context "given an invalid date value" do
        it "blows up" do
          expect { registry.load(:invalid_date, type: :date) }.
            to raise_error(Prius::TypeMismatchError)
        end
      end

      context "given a non-date value" do
        it "blows up" do
          expect { registry.load(:name, type: :date) }.
            to raise_error(Prius::TypeMismatchError)
        end
      end
    end
  end

  describe "#get" do
    context "given a name that has been loaded" do
      before { registry.load(:name) }

      it "returns the value" do
        expect(registry.get(:name)).to eq("Harry")
      end
    end

    context "given a name that hasn't been loaded" do
      it "blows up" do
        expect { registry.get(:name) }.
          to raise_error(Prius::UndeclaredNameError)
      end
    end

    context "given a nillable name that has been loaded" do
      before { registry.load(:lightsabre, required: false) }

      it "returns nil" do
        expect(registry.get(:lightsabre)).to be_nil
      end
    end
  end
end
