@testset "Covariances" begin
  d = 4
  D = 5
  table = (x1=rand(100), x2=rand(100), x3=rand(100), x4=rand(100), x5=rand(100))

  Τ = variation(table)
  Σ = alrcov(table)
  Γ = clrcov(table)
  A = lrarray(table)

  # Testing matrix forms transformations (Aitchison 1986, pages 82 and 83)
  ## Test matrix transformation from Τ to Σ (4.25)
  @test Σ ≈ -0.5 * F * Τ * F'

  ## Test matrix transformation from Τ to Γ (4.26)
  @test Γ ≈ -0.5 * G * Τ * G

  ## Test matrix transformation from Σ to Τ (4.27)
  Γ₀ = F' * inv(H(d)) * Σ * inv(H(d)) * F
  @test Τ ≈ J * Diagonal(Γ₀) + Diagonal(Γ₀) * J - 2 * Γ₀

  ## Test matrix transformation from Σ to Γ (4.28)
  @test Γ ≈ F' * inv(H(d)) * Σ * inv(H(d)) * F

  ## Test matrix transformation from Γ to Τ (4.29)
  @test Τ ≈ J * Diagonal(Γ) + Diagonal(Γ) * J - 2 * Γ

  ## Test matrix transformation from Γ to Σ (4.30)
  @test Σ ≈ F * Γ * F'
end