def update_quality(items)
  items.each do |item|
    update_quality_for(item)
  end
end

def update_quality_for(item)
  update_quality_for_a_passed_day(item)
  update_sell_in_for_sulfuras(item)
  update_quality_after_sell_in_date(item)
end

def update_quality_for_a_passed_day(item)
  if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
    if item.quality > 0
      if item.name.include?('Conjured')
        item.quality -= 2
      elsif item.name != 'Sulfuras, Hand of Ragnaros'
        item.quality -= 1
      end
    end
  else
    if item.quality < 50
      item.quality += 1
      if item.name == 'Backstage passes to a TAFKAL80ETC concert'
        if item.sell_in < 11
          item.quality += 1
        end
        if item.sell_in < 6
          item.quality += 1
        end
      end
    end
  end
end

def update_sell_in_for_sulfuras(item)
  if item.name != 'Sulfuras, Hand of Ragnaros'
    item.sell_in -= 1
  end
end

def update_quality_after_sell_in_date(item)
  if item.sell_in < 0
    if item.name != "Aged Brie"
      if item.name != 'Backstage passes to a TAFKAL80ETC concert'
        if item.quality > 0
          # per spec, Conjured items's quality lowering doesn't double after sell-in date
          if item.name != 'Sulfuras, Hand of Ragnaros' && !item.name.include?('Conjured')
            item.quality -= 1
          end
        end
      else
        item.quality = 0
      end
    else
      if item.quality < 50
        item.quality += 1
      end
    end
  end
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
