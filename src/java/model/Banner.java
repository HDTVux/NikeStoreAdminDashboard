package model;

import java.sql.Timestamp;

public class Banner {
  private int id;
  private String title;
  private String subtitle;
  private String imageUrl;
  private String deeplink;
  private Integer sortOrder;
  private boolean active;
  private Timestamp startsAt;
  private Timestamp endsAt;

  // getters/setters
  public int getId(){return id;}
  public void setId(int id){this.id=id;}
  public String getTitle(){return title;}
  public void setTitle(String title){this.title=title;}
  public String getSubtitle(){return subtitle;}
  public void setSubtitle(String subtitle){this.subtitle=subtitle;}
  public String getImageUrl(){return imageUrl;}
  public void setImageUrl(String imageUrl){this.imageUrl=imageUrl;}
  public String getDeeplink(){return deeplink;}
  public void setDeeplink(String deeplink){this.deeplink=deeplink;}
  public Integer getSortOrder(){return sortOrder;}
  public void setSortOrder(Integer sortOrder){this.sortOrder=sortOrder;}
  public boolean isActive(){return active;}
  public void setActive(boolean active){this.active=active;}
  public Timestamp getStartsAt(){return startsAt;}
  public void setStartsAt(Timestamp startsAt){this.startsAt=startsAt;}
  public Timestamp getEndsAt(){return endsAt;}
  public void setEndsAt(Timestamp endsAt){this.endsAt=endsAt;}
}
