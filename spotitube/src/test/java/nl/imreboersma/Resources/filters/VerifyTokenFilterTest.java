package nl.imreboersma.Resources.filters;

import nl.imreboersma.DAO.iUserDAO;
import nl.imreboersma.Domain.User;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.ws.rs.BadRequestException;
import javax.ws.rs.NotAuthorizedException;
import javax.ws.rs.container.ContainerRequestContext;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.SecurityContext;
import javax.ws.rs.core.UriInfo;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.*;

class VerifyTokenFilterTest {
  private static final String TOKEN = "SecretToken";
  private ContainerRequestContext containerRequestContext;
  private UriInfo uriInfo;
  private MultivaluedMap<String, String> multivaluedMap;
  private SecurityContext securityContext;

  @BeforeEach
  @SuppressWarnings("unchecked")
  void setUp() {
    containerRequestContext = mock(ContainerRequestContext.class);
    uriInfo = mock(UriInfo.class);
    multivaluedMap = (MultivaluedMap<String, String>) mock(MultivaluedMap.class);
    securityContext = mock(SecurityContext.class);

  }

  @AfterEach
  void tearDown() {
    containerRequestContext = null;
    uriInfo = null;
    multivaluedMap = null;
  }

  @Test
  void filterNoQueryParameter() {
    // Arrange
    when(multivaluedMap.getFirst(VerifyTokenFilter.KEY)).thenReturn(null);
    when(uriInfo.getQueryParameters()).thenReturn(multivaluedMap);
    when(containerRequestContext.getUriInfo()).thenReturn(uriInfo);

    VerifyTokenFilter verifyTokenFilter = new VerifyTokenFilter(mock(iUserDAO.class));

    // Act & Assert
    assertThrows(BadRequestException.class, () -> verifyTokenFilter.filter(containerRequestContext));
  }

  @Test
  void filterInvalidTokenTest() {
    // Arrange
    when(multivaluedMap.getFirst(VerifyTokenFilter.KEY)).thenReturn(TOKEN);
    when(uriInfo.getQueryParameters()).thenReturn(multivaluedMap);
    when(containerRequestContext.getUriInfo()).thenReturn(uriInfo);

    iUserDAO userDAO = mock(iUserDAO.class);
    when(userDAO.getUserFromToken(TOKEN)).thenReturn(Optional.empty());

    VerifyTokenFilter verifyTokenFilter = new VerifyTokenFilter(userDAO);

    // Act & Assert
    assertThrows(NotAuthorizedException.class, () -> verifyTokenFilter.filter(containerRequestContext));
  }

  @Test
  void filterValidTokenTest() {
    // Arrange
    when(multivaluedMap.getFirst(VerifyTokenFilter.KEY)).thenReturn(TOKEN);
    when(uriInfo.getQueryParameters()).thenReturn(multivaluedMap);
    when(containerRequestContext.getUriInfo()).thenReturn(uriInfo);

    iUserDAO userDAO = mock(iUserDAO.class);
    when(userDAO.getUserFromToken(TOKEN)).thenReturn(Optional.of(new User()));

    VerifyTokenFilter verifyTokenFilter = new VerifyTokenFilter(userDAO);

    // Act
    verifyTokenFilter.filter(containerRequestContext);

    // Assert
    verify(containerRequestContext, times(1)).setSecurityContext(any());
  }
}