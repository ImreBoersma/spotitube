package nl.imreboersma.Resources;

import nl.imreboersma.DAO.iPlaylistDAO;
import nl.imreboersma.DAO.iTrackDAO;
import nl.imreboersma.DTO.TrackDTO;
import nl.imreboersma.DTO.playlists.TracksDTO;
import nl.imreboersma.Domain.Track;
import nl.imreboersma.Resources.filters.VerifyToken;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.stream.Collectors;

@Produces(MediaType.APPLICATION_JSON)
@Path("/tracks")
@VerifyToken
public class Tracks {
  private iPlaylistDAO playlistDAO;
  private iTrackDAO trackDAO;

  @GET
  public Response all(@QueryParam("forPlaylist") int playlistId) {
    if(!playlistDAO.exists(playlistId))
      return Response.status(Response.Status.NOT_FOUND).build();
    final ArrayList<Track> tracks = trackDAO.getTracksNotInPlaylist(playlistId);
    TracksDTO response = new TracksDTO();
    response.tracks = tracks.stream().map(track -> {
      final TrackDTO trackDTO = new TrackDTO();
      trackDTO.id = track.getId();
      trackDTO.title = track.getTitle();
      trackDTO.performer = track.getPerformer();
      trackDTO.duration = track.getDuration();
      trackDTO.album = track.getAlbum();
      trackDTO.playCount = track.getPlayCount();
      trackDTO.publicationDate = track.getPublicationDate().toString();
      trackDTO.description = track.getDescription();
      trackDTO.offlineAvailable = track.isOfflineAvailable();
      return trackDTO;
    }).collect(Collectors.toCollection(ArrayList::new));
    return Response.ok().entity(response).build();
  }

  @Inject
  public void setPlaylistDAO(iPlaylistDAO playlistDAO) {
    this.playlistDAO = playlistDAO;
  }

  @Inject
  public void setTrackDAO(iTrackDAO trackDAO) {
    this.trackDAO = trackDAO;
  }
}
