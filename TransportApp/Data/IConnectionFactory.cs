using System.Data;

namespace TransportApp.Data;

public interface IConnectionFactory
{
    IDbConnection CreateConnection();
}