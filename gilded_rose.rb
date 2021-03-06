def update_quality(items)
  items.each do |item|
    update_quality_for(item)
  end
end

def update_quality_for(item)
  update_quality_for_a_passed_day(item)
  update_sell_in(item)
  update_quality_after_sell_in_date(item)
end

def update_quality_for_a_passed_day(item)
  if is_aged_brie?(item) || is_backstage_pass?(item)
    increase_quality(item)
    increase_quality_further_if_backstage_pass(item)
  else
    decrease_quality(item)
    decrease_quality(item) if is_conjured?(item)
  end
end

def update_sell_in(item)
  item.sell_in -= 1 unless is_legendary?(item)
end

def update_quality_after_sell_in_date(item)
  return unless item.sell_in < 0
  if is_aged_brie?(item)
    increase_quality(item)
  else
    if is_backstage_pass?(item)
      item.quality = 0
    else
      # per spec, Conjured items's quality lowering doesn't double after sell-in date
      decrease_quality(item) unless is_conjured?(item)
    end
  end
end

def increase_quality_further_if_backstage_pass(item)
  return unless is_backstage_pass?(item)
  increase_quality(item) if item.sell_in < 11
  increase_quality(item) if item.sell_in < 6
end

# quality methods
def increase_quality(item)
  return unless item.quality < 50
  item.quality += 1
end

def decrease_quality(item)
  return unless item.quality > 0
  item.quality -= 1 unless is_legendary?(item)
end

# type checks
def is_aged_brie?(item)
  item.name == 'Aged Brie'
end

def is_backstage_pass?(item)
  item.name.include?('Backstage pass')
end

def is_conjured?(item)
  item.name.include?('Conjured')
end

def is_legendary?(item)
  item.name == 'Sulfuras, Hand of Ragnaros'
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]
