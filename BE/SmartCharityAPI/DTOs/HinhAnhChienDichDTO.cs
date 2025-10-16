namespace SmartCharityAPI.DTOs
{
    public class HinhAnhChienDichDTO
    {
        public int Id { get; set; }
        public string Url { get; set; } = "";

        public int ChienDichId { get; set; }
        public bool IsChinh { get; set; }
    }

}
