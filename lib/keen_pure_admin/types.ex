defmodule PureAdmin.Types do
  @moduledoc """
  Shared type definitions for PureAdmin components.
  """

  @type variant ::
          :primary | :secondary | :success | :danger | :warning | :info | :light | :dark

  @type size :: :xs | :sm | :lg | :xl

  @type validation_state :: :success | :warning | :error

  @type horizontal_alignment :: :start | :center | :end | :between | :around

  @type vertical_alignment :: :top | :middle | :bottom

  @variants ~w(primary secondary success danger warning info light dark)
  @sizes ~w(xs sm lg xl)

  @doc "List of valid variant strings."
  @spec variants() :: [String.t()]
  def variants, do: @variants

  @doc "List of valid size strings."
  @spec sizes() :: [String.t()]
  def sizes, do: @sizes
end
