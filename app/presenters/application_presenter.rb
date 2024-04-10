class ApplicationPresenter < SimpleDelegator

  def initialize model
    @object = model
    super(model)
  end

end