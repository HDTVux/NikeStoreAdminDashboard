package model;

public class OrderItem {
  private int id;
  private int orderId;
  private int productId;
  private Integer variantId;
  private int quantity;
  private double price;
  private String productName; // join

  // getters/setters
  public int getId(){return id;}
  public void setId(int id){this.id=id;}
  public int getOrderId(){return orderId;}
  public void setOrderId(int orderId){this.orderId=orderId;}
  public int getProductId(){return productId;}
  public void setProductId(int productId){this.productId=productId;}
  public Integer getVariantId(){return variantId;}
  public void setVariantId(Integer variantId){this.variantId=variantId;}
  public int getQuantity(){return quantity;}
  public void setQuantity(int quantity){this.quantity=quantity;}
  public double getPrice(){return price;}
  public void setPrice(double price){this.price=price;}
  public String getProductName(){return productName;}
  public void setProductName(String productName){this.productName=productName;}
}
