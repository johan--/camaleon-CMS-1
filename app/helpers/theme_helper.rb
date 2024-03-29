=begin
  Camaleon CMS is a content management system
  Copyright (C) 2015 by Owen Peredo Diaz
  Email: owenperedo@gmail.com
  This program is free software: you can redistribute it and/or modify   it under the terms of the GNU Affero General Public License as  published by the Free Software Foundation, either version 3 of the  License, or (at your option) any later version.
  This program is distributed in the hope that it will be useful,  but WITHOUT ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the  GNU Affero General Public License (GPLv3) for more details.
=end
module ThemeHelper

  def theme_init()
    @_front_breadcrumb = []
  end

  # assign the layout for this request
  # asset: asset file name, if asset is present return full path to this asset
  # layout_name: layout name
  def theme_layout(layout_name, theme_name = nil)
    path = "#{theme_name || current_theme.slug}/views/layouts/#{layout_name}"
    self.class.send(:layout, path)
    path
  end

  # return theme full asset path
  # theme_name: theme name, if nil, then will use current theme
  # asset: asset file name, if asset is present return full path to this asset
  # sample: <script src="<%= theme_asset_path("js/admin.js") %>"></script>
  def theme_asset_path(asset = nil, theme_name = nil)
    "#{root_url(locale: nil)}assets/themes/#{theme_name || current_theme.slug }/assets/#{asset}"
  end

  # return theme full view path
  # theme_key: theme folder name
  # view_name: name of the view or template
  def theme_view(theme_key, view_name)
    begin
      p = "themes/" if request.env['PATH_INFO'].start_with?("/admin")
    rescue
      p = ""
    end
    "#{p if p.present?}#{theme_key}/views/#{view_name}"
  end

  # return theme key for current theme file (helper|controller|view)
  def self_theme_key
    k = "app/apps/themes/"
    f = caller.first
    f.split(k).last.split("/").first if f.include?(k)
  end
end