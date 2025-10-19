package dao;

import model.Banner;
import java.sql.*;
import java.util.*;

public class BannerDAO {

private Banner map(ResultSet rs) throws SQLException {
    Banner b = new Banner();
    b.setId(rs.getInt("id"));
    b.setTitle(rs.getString("title"));
    b.setSubtitle(rs.getString("subtitle"));

    String relativePath = rs.getString("image_url");
    if (relativePath != null && !relativePath.isBlank()) {
        // ✅ tự nối prefix để JSP hiển thị được
        b.setImageUrl("http://localhost/" + relativePath);
    }

    b.setDeeplink(rs.getString("deeplink"));
    b.setSortOrder((Integer) rs.getObject("sort_order"));
    b.setActive(rs.getBoolean("is_active"));
    b.setStartsAt(rs.getTimestamp("starts_at"));
    b.setEndsAt(rs.getTimestamp("ends_at"));
    return b;
}


  public List<Banner> listAll(){
    List<Banner> list = new ArrayList<>();
    String sql = "SELECT * FROM banners ORDER BY sort_order ASC, id DESC";
    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()){
      while(rs.next()) list.add(map(rs));
    }catch(Exception e){ e.printStackTrace(); }
    return list;
  }

  public Banner findById(int id){
    String sql = "SELECT * FROM banners WHERE id=?";
    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql)){
      ps.setInt(1, id);
      try(ResultSet rs = ps.executeQuery()){
        if (rs.next()) return map(rs);
      }
    }catch(Exception e){ e.printStackTrace(); }
    return null;
  }

  public void insert(Banner b){
    String sql = """
      INSERT INTO banners(title, subtitle, image_url, deeplink, sort_order, is_active, starts_at, ends_at)
      VALUES(?,?,?,?,?, ?, ?, ?)
      """;
    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql)){
      ps.setString(1, b.getTitle());
      ps.setString(2, b.getSubtitle());
      ps.setString(3, b.getImageUrl());
      ps.setString(4, b.getDeeplink());
      if (b.getSortOrder()==null) ps.setNull(5, Types.INTEGER); else ps.setInt(5, b.getSortOrder());
      ps.setBoolean(6, b.isActive());
      if (b.getStartsAt()==null) ps.setNull(7, Types.TIMESTAMP); else ps.setTimestamp(7, b.getStartsAt());
      if (b.getEndsAt()==null) ps.setNull(8, Types.TIMESTAMP); else ps.setTimestamp(8, b.getEndsAt());
      ps.executeUpdate();
    }catch(Exception e){ e.printStackTrace(); }
  }

  public void update(Banner b){
    String sql = """
      UPDATE banners SET title=?, subtitle=?, image_url=?, deeplink=?, sort_order=?, is_active=?, starts_at=?, ends_at=?
      WHERE id=?
      """;
    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql)){
      ps.setString(1, b.getTitle());
      ps.setString(2, b.getSubtitle());
      ps.setString(3, b.getImageUrl());
      ps.setString(4, b.getDeeplink());
      if (b.getSortOrder()==null) ps.setNull(5, Types.INTEGER); else ps.setInt(5, b.getSortOrder());
      ps.setBoolean(6, b.isActive());
      if (b.getStartsAt()==null) ps.setNull(7, Types.TIMESTAMP); else ps.setTimestamp(7, b.getStartsAt());
      if (b.getEndsAt()==null) ps.setNull(8, Types.TIMESTAMP); else ps.setTimestamp(8, b.getEndsAt());
      ps.setInt(9, b.getId());
      ps.executeUpdate();
    }catch(Exception e){ e.printStackTrace(); }
  }

  public void toggle(int id){
    String sql = "UPDATE banners SET is_active = NOT is_active WHERE id=?";
    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql)){
      ps.setInt(1, id);
      ps.executeUpdate();
    }catch(Exception e){ e.printStackTrace(); }
  }

  public void delete(int id){
    String sql = "DELETE FROM banners WHERE id=?";
    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql)){
      ps.setInt(1, id);
      ps.executeUpdate();
    }catch(Exception e){ e.printStackTrace(); }
  }
}
