package nl.imreboersma.DAO;

import nl.imreboersma.domain.Playlist;
import nl.imreboersma.domain.Track;

import javax.annotation.Resource;
import javax.enterprise.inject.Default;
import javax.sql.DataSource;
import javax.ws.rs.InternalServerErrorException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

@Default
public class PlaylistDAO implements iPlaylistDAO {
  @Resource(name = "jdbc/Spotitube")
  DataSource dataSource;

  @Override
  public ArrayList<Playlist> getAllPlaylistsCheckOwner(int userId) {
    try(Connection connection = dataSource.getConnection()) {
      PreparedStatement statement = connection.prepareStatement("SELECT IIF(playlist.owner_user_id = '" + userId + "', 1, 0) as owner, * FROM [playlist] LEFT JOIN playlist_tracks pt on playlist.id = pt.playlist_id LEFT JOIN track t on pt.track_id = t.id");
      ResultSet resultSet = statement.executeQuery();

      HashMap<Integer, Playlist> playlistHashMap = new HashMap<>();
      while(resultSet.next()) {
        int playlistId = resultSet.getInt("id");

        Playlist playlist;
        if(!playlistHashMap.containsKey(playlistId)) {
          playlist = new Playlist();

          playlist.setId(playlistId);
          playlist.setName(resultSet.getString("name"));
          playlist.setOwner(resultSet.getBoolean("owner"));
          playlistHashMap.put(playlistId, playlist);
        } else {
          playlist = playlistHashMap.get(playlistId);
        }

        Track track = createTrack(resultSet);

        if(track == null)
          continue;

        playlist.addTrack(track);
      }
      return new ArrayList<>(playlistHashMap.values());
    } catch(SQLException e) {
      throw new InternalServerErrorException(e);
    }
  }

  private Track createTrack(ResultSet resultSet) throws SQLException {
    Track track = new Track();
    track.setId(resultSet.getInt("track_id"));
    if(track.getId() == 0) {
      return null;
    }
    track.setTitle(resultSet.getString("title"));
    track.setPerformer(resultSet.getString("performer"));
    track.setDuration(resultSet.getInt("duration"));
    track.setAlbum(resultSet.getString("album"));
    track.setPlayCount(resultSet.getInt("play_count"));
    track.setPublicationDate(resultSet.getDate("publication_date"));
    track.setDescription(resultSet.getString("description"));
    track.setOfflineAvailable(resultSet.getBoolean("offline_available"));
    return track;
  }

  @Override
  public void deletePlaylist(int playlistId) {
    try(Connection connection = dataSource.getConnection()) {
      PreparedStatement statement = connection.prepareStatement("DELETE FROM [playlist] WHERE [playlist].id = ?");
      statement.setInt(1, playlistId);
      statement.executeQuery();
    } catch(SQLException e) {
      throw new InternalServerErrorException(e);
    }
  }

  @Override
  public void addPlaylist(int userId, String name) {
    try(Connection connection = dataSource.getConnection()) {
      String sql = "INSERT INTO [playlist] (owner_user_id, name) VALUES(?, ?)";
      PreparedStatement statement = connection.prepareStatement(sql);
      statement.setInt(1, userId);
      statement.setString(2, name);
      statement.execute();
    } catch(SQLException e) {
      throw new InternalServerErrorException(e);
    }
  }

  @Override
  public void editPlaylist(int playlistId, String name) {
    try(Connection connection = dataSource.getConnection()) {
      String sql = "UPDATE [playlist] SET name = ? WHERE id = ?";
      PreparedStatement statement = connection.prepareStatement(sql);
      statement.setString(1, name);
      statement.setInt(2, playlistId);
      statement.execute();
    } catch(SQLException e) {
      throw new InternalServerErrorException(e);
    }
  }

  @Override
  public ArrayList<Track> getAllTracks(int playlistId) {
    try(Connection connection = dataSource.getConnection()) {
      PreparedStatement statement = connection.prepareStatement("SELECT [track].*, [playlist_tracks].offline_available FROM [playlist_tracks] LEFT JOIN [track] ON [playlist_tracks].track_id = [track].id WHERE [playlist_tracks].playlist_id = ?");
      statement.setInt(1, playlistId);
      ResultSet resultSet = statement.executeQuery();

      ArrayList<Track> tracks = new ArrayList<>();
      while(resultSet.next()) {
        tracks.add(createTrack(resultSet));
      }
      return tracks;
    } catch(SQLException e) {
      throw new InternalServerErrorException(e);
    }
  }

  @Override
  public boolean exists(int playlistId) {
    try(Connection connection = dataSource.getConnection()) {
      String sql = "SELECT 1 FROM [playlist] WHERE id = ?";
      PreparedStatement statement = connection.prepareStatement(sql);
      statement.setInt(1, playlistId);
      statement.execute();
      return statement.getResultSet().next();
    } catch(SQLException e) {
      throw new InternalServerErrorException(e);
    }
  }
}
