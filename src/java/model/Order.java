package model;

import java.sql.Timestamp;
import java.util.List;

public class Order {
  private int id;
  private int userId;
  private String status;
  private double totalPrice;
  private String shippingAddress;
  private Timestamp createdAt;
  private String paymentMethod;
  private double shippingFee;
  private double subtotal;

  private String userEmail; // join hiển thị
  private List<OrderItem> items;

  // getters/setters...
  public int getId(){return id;}
  public void setId(int id){this.id=id;}
  public int getUserId(){return userId;}
  public void setUserId(int userId){this.userId=userId;}
  public String getStatus(){return status;}
  public void setStatus(String status){this.status=status;}
  public double getTotalPrice(){return totalPrice;}
  public void setTotalPrice(double totalPrice){this.totalPrice=totalPrice;}
  public String getShippingAddress(){return shippingAddress;}
  public void setShippingAddress(String shippingAddress){this.shippingAddress=shippingAddress;}
  public Timestamp getCreatedAt(){return createdAt;}
  public void setCreatedAt(Timestamp createdAt){this.createdAt=createdAt;}
  public String getPaymentMethod(){return paymentMethod;}
  public void setPaymentMethod(String paymentMethod){this.paymentMethod=paymentMethod;}
  public double getShippingFee(){return shippingFee;}
  public void setShippingFee(double shippingFee){this.shippingFee=shippingFee;}
  public double getSubtotal(){return subtotal;}
  public void setSubtotal(double subtotal){this.subtotal=subtotal;}
  public String getUserEmail(){return userEmail;}
  public void setUserEmail(String userEmail){this.userEmail=userEmail;}
  public List<OrderItem> getItems(){return items;}
  public void setItems(List<OrderItem> items){this.items=items;}
}
