module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Travel Crumbz"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def date_ordinal_format(date)
    unless date.blank?
      #date.strftime("%B %-d, %Y")
      date.to_formatted_s(:long_ordinal)
    end
  end

  def date_short_format(date)
    unless date.blank?
      date.strftime("%m/%d/%Y")
    end
  end

  def valid_month(month)
    if month.blank?
      return false
    else
      if month.to_i.between?(1,12)
        return true
      else
        return false
      end
    end
  end

  def valid_year(year)
    if year.blank?
      return false
    else
      if year.to_i.between?(1900,2013)
        return true
      else
        return false
      end
    end
  end

  ###################
  #  Field Options  #
  ###################

  def tiles
    [2, 4, 6, 8, 9]
  end

  def sort_key
    [
      ['Travel date','start_date'],
      ['Entry post date','created_at'],
      ['Likes count','likes']
    ]
  end

  def sort_order
    [
      ['Ascending','ASC'],
      ['Descending','DESC']
    ]
  end

  def months
    {
      '1' => 'Jan',
      '2' => 'Feb',
      '3' => 'Mar',
      '4' => 'Apr',
      '5' => 'May',
      '6' => 'Jun',
      '7' => 'Jul',
      '8' => 'Aug',
      '9' => 'Sep',
      '10' => 'Oct',
      '11' => 'Nov',
      '12' => 'Dec'
    }
  end

  def countries
    [
      [''],
      ['Argentina'],
      ['Australia'],
      ['Austria'],
      ['Bolivia'],
      ['Brazil'],
      ['Canada'],
      ['Chile'],
      ['China'],
      ['Croatia'],
      ['Czech Republic'],
      ['Denmark'],
      ['Ecuador'],
      ['France'],
      ['Germany'],
      ['Hungary'],
      ['Indonesia'],
      ['Italy'],
      ['Japan'],
      ['Laos'],
      ['Malaysia'],
      ['Norway'],
      ['Peru'],
      ['Slovenia'],
      ['Spain'],
      ['Sweden'],
      ['Thailand'],
      ['UK'],
      ['USA'],
      ['Vietnam']
    ]
  end
  
end
