require_relative '../../../src/Item/Food/food.rb'
require_relative '../../../src/Entity/entity.rb'

RSpec.describe Food do
  context "constructor" do
    it "has the correct default parameters" do
      food = Food.new
      expect(food.name).to eq "Food"
      expect(food.price).to eq 0
      expect(food.consumable).to eq true
      expect(food.recovers).to eq 0
    end

    it "correctly assigns custom parameters" do
      magic_banana = Food.new(name: "Magic Banana",
                              price: 5,
                              consumable: false,
                              recovers: 1000)
      expect(magic_banana.name).to eq "Magic Banana"
      expect(magic_banana.price).to eq 5
      expect(magic_banana.consumable).to eq false
      expect(magic_banana.recovers).to eq 1000
    end
  end

  context "use" do
    it "heals the entity's HP in a trivial case" do
      entity = Entity.new(hp: 5, max_hp: 20)
      food = Food.new(recovers: 10)
      food.use(entity)
      expect(entity.hp).to eq 15
    end

    it "does not heal over the entity's max HP" do
      entity = Entity.new(hp: 15, max_hp: 20)
      food = Food.new(recovers: 10)
      food.use(entity)
      expect(entity.hp).to eq 20
    end

    it "has a dynamic message for when food is eaten" do
      entity = Entity.new(max_hp: 20, hp: 10)
      food = Food.new(name: 'Fruit', recovers: 5)
      recovers = food.recovers
      food.use(entity)
      expected = "#{entity.name} uses Fruit and recovers "\
        "5 HP!\n\nHP: 15/20"

      expect(food.effects_message(entity, recovers)).to eq(expected)

      food.use(entity)
      if entity.hp + food.recovers > entity.max_hp
        new_recover = entity.max_hp - entity.hp
      else
        new_recover = food.recovers
      end
      expected = "#{entity.name} uses Fruit and recovers "\
        "0 HP!\n\nHP: 20/20"

      expect(food.effects_message(entity, new_recover)).to eq(expected)
    end
  end

end
