module ToUseCreditCardsHelper
  def select_banks(f)
    f.select :bank_id, Bank.all.map { |b| [b.name, b.id]}, {},  class: "select2"
  end
end
