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
    if item.quality < 50
      increase_quality(item)
      if is_backstage_pass?(item)
        if item.sell_in < 11
          increase_quality(item)
        end
        if item.sell_in < 6
          increase_quality(item)
        end
      end
    end
  else
    if item.quality > 0
      if is_conjured?(item)
        decrease_quality(item, 2)
      elsif !is_legendary?(item)
        decrease_quality(item)
      end
    end
  end
end

def update_sell_in(item)
  item.sell_in -= 1 unless is_legendary?(item)
end

def update_quality_after_sell_in_date(item)
  if item.sell_in < 0
    if is_aged_brie?(item)
      if item.quality < 50
        increase_quality(item)
      end
    else
      if is_backstage_pass?(item)
        item.quality = 0
      else
        if item.quality > 0
          # per spec, Conjured items's quality lowering doesn't double after sell-in date
          decrease_quality(item) unless is_legendary?(item) || is_conjured?(item)
        end
      end
    end
  end
end

# quality methods
def increase_quality(item, increase = 1)
  item.quality += increase
end

def decrease_quality(item, decrease = 1)
  item.quality -= decrease
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
