# app/helpers/breadcrumbs_helper.rb
module BreadcrumbsHelper
  def breadcrumbs
    crumbs = []
    crumbs << link_to('Home', root_path)

    case [controller_name, action_name]
    when ['categories', 'show']
      crumbs += category_breadcrumbs
    when ['products', 'show']
      crumbs += product_breadcrumbs
    when ['products', 'index']
      crumbs << 'Products'
    when ['categories', 'index']
      crumbs << 'Categories'
    end

    safe_join(crumbs, ' &raquo; '.html_safe)
  end

  private

  def category_breadcrumbs
    category = Category.find(params[:id])
    [
      link_to('Categories', categories_path),
      category.name
    ]
  end

  def product_breadcrumbs
    product = Product.find(params[:id])
    category = product.category
    [
      link_to('Categories', categories_path),
      link_to(category.name, category_path(category)),
      product.name
    ]
  end
end
